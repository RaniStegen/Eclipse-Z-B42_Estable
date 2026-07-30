#!/usr/bin/env python3
"""Valida la estructura activa del modpack Eclipse-Z para Project Zomboid 42.20."""

from __future__ import annotations

import argparse
import json
import re
from collections import defaultdict
from pathlib import Path

TARGET = (42, 20, 0)
VERSION_RE = re.compile(r"^\d+(?:\.\d+)*$")


def version_tuple(value: str) -> tuple[int, ...]:
    parts = tuple(int(part) for part in value.split("."))
    return parts + (0,) * (3 - len(parts))


def parse_manifest(path: Path) -> dict[str, list[str]]:
    values: dict[str, list[str]] = defaultdict(list)
    for raw_line in path.read_text(encoding="utf-8-sig", errors="replace").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()].append(value.strip())
    return dict(values)


def choose_manifest(mod_root: Path) -> Path | None:
    layers: list[tuple[tuple[int, ...], Path]] = []
    for child in mod_root.iterdir():
        if child.is_dir() and VERSION_RE.fullmatch(child.name):
            version = version_tuple(child.name)
            manifest = child / "mod.info"
            if version <= TARGET and manifest.is_file():
                layers.append((version, manifest))
    if layers:
        return max(layers, key=lambda item: item[0])[1]
    common = mod_root / "common" / "mod.info"
    return common if common.is_file() else None


def find_asset(mod_root: Path, filename: str) -> bool:
    target = filename.casefold()
    return any(
        path.name.casefold() == target for path in mod_root.rglob("*") if path.is_file()
    )


def load_json(path: Path) -> object:
    data = path.read_bytes()
    encoding = "utf-16" if data.startswith((b"\xff\xfe", b"\xfe\xff")) else "utf-8-sig"
    return json.loads(data.decode(encoding))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--server-config",
        type=Path,
        help="Archivo .ini del servidor cuya lista Mods= se debe validar.",
    )
    parser.add_argument(
        "--report",
        type=Path,
        default=Path("docs/modpack-validation-report.json"),
    )
    args = parser.parse_args()

    repo = Path(__file__).resolve().parents[1]
    mod_roots = sorted(
        (
            child
            for mods_dir in repo.rglob("mods")
            if mods_dir.is_dir() and mods_dir.parent.name == "Contents"
            for child in mods_dir.iterdir()
            if child.is_dir()
        ),
        key=lambda path: str(path).casefold(),
    )

    selected: list[dict[str, object]] = []
    errors: list[dict[str, str]] = []
    warnings: list[dict[str, str]] = []
    ids: dict[str, list[Path]] = defaultdict(list)

    for mod_root in mod_roots:
        manifest = choose_manifest(mod_root)
        if manifest is None:
            errors.append(
                {"kind": "manifest_missing", "path": str(mod_root.relative_to(repo))}
            )
            continue
        parsed = parse_manifest(manifest)
        mod_id = (parsed.get("id") or [""])[-1].strip()
        if not mod_id:
            errors.append(
                {"kind": "id_missing", "path": str(manifest.relative_to(repo))}
            )
            continue
        ids[mod_id].append(mod_root)
        requires = [
            requirement.strip().lstrip("\\/")
            for value in parsed.get("require", [])
            for requirement in value.split(",")
            if requirement.strip()
        ]
        packs = [value for value in parsed.get("pack", []) if value]
        tiledefs = [
            value.rsplit(maxsplit=1)[0]
            if value.rsplit(maxsplit=1)[-1].isdigit()
            else value
            for value in parsed.get("tiledef", [])
            if value
        ]
        for pack in packs:
            if not find_asset(mod_root, f"{pack}.pack"):
                errors.append(
                    {
                        "kind": "pack_missing",
                        "id": mod_id,
                        "value": pack,
                        "path": str(manifest.relative_to(repo)),
                    }
                )
        for tiledef in tiledefs:
            if not find_asset(mod_root, f"{tiledef}.tiles"):
                errors.append(
                    {
                        "kind": "tiledef_missing",
                        "id": mod_id,
                        "value": tiledef,
                        "path": str(manifest.relative_to(repo)),
                    }
                )
        selected.append(
            {
                "id": mod_id,
                "root": str(mod_root.relative_to(repo)),
                "manifest": str(manifest.relative_to(repo)),
                "requires": requires,
                "packs": packs,
                "tiledefs": tiledefs,
            }
        )

    for mod_id, roots in ids.items():
        if len(roots) > 1:
            errors.append(
                {
                    "kind": "duplicate_active_id",
                    "id": mod_id,
                    "paths": "; ".join(
                        str(path.relative_to(repo)) for path in roots
                    ),
                }
            )

    active_ids = set(ids)
    for mod in selected:
        for requirement in mod["requires"]:
            if requirement not in active_ids:
                errors.append(
                    {
                        "kind": "requirement_missing",
                        "id": str(mod["id"]),
                        "value": str(requirement),
                        "path": str(mod["manifest"]),
                    }
                )

    server_mods: list[str] = []
    server_workshop_items: list[str] = []
    server_map = ""
    if args.server_config:
        config = args.server_config.resolve()
        if not config.is_file():
            errors.append({"kind": "server_config_missing", "path": str(config)})
        else:
            for line in config.read_text(
                encoding="utf-8-sig", errors="replace"
            ).splitlines():
                if line.startswith("Mods="):
                    server_mods = [
                        entry.strip().lstrip("\\/")
                        for entry in line[5:].split(";")
                        if entry.strip()
                    ]
                elif line.startswith("WorkshopItems="):
                    server_workshop_items = [
                        entry.strip()
                        for entry in line[len("WorkshopItems=") :].split(";")
                        if entry.strip()
                    ]
                elif line.startswith("Map="):
                    server_map = line[4:].strip()
            for mod_id in server_mods:
                if mod_id not in active_ids:
                    errors.append(
                        {
                            "kind": "server_mod_missing",
                            "id": mod_id,
                            "path": str(config),
                        }
                    )
            if len(server_mods) != len(set(server_mods)):
                errors.append(
                    {
                        "kind": "duplicate_server_mod",
                        "path": str(config),
                    }
                )
            unused = sorted(active_ids - set(server_mods))
            if unused:
                errors.append(
                    {
                        "kind": "active_mod_not_in_server_config",
                        "values": "; ".join(unused),
                    }
                )

    repository_workshop_items: list[str] = []
    for workshop_file in sorted(repo.glob("*/workshop.txt")):
        parsed_workshop = parse_manifest(workshop_file)
        workshop_id = (parsed_workshop.get("id") or [""])[-1].strip()
        if workshop_id:
            repository_workshop_items.append(workshop_id)
    if args.server_config:
        missing_workshop = sorted(
            set(repository_workshop_items) - set(server_workshop_items)
        )
        extra_workshop = sorted(
            set(server_workshop_items) - set(repository_workshop_items)
        )
        if missing_workshop:
            errors.append(
                {
                    "kind": "server_workshop_items_missing",
                    "values": "; ".join(missing_workshop),
                }
            )
        if extra_workshop:
            errors.append(
                {
                    "kind": "server_workshop_items_unknown",
                    "values": "; ".join(extra_workshop),
                }
            )

    invalid_json: list[dict[str, str]] = []
    json_files = list(repo.rglob("*.json"))
    for path in json_files:
        try:
            load_json(path)
        except (OSError, UnicodeError, json.JSONDecodeError) as exc:
            invalid_json.append(
                {"path": str(path.relative_to(repo)), "error": str(exc)}
            )
    errors.extend({"kind": "invalid_json", **item} for item in invalid_json)

    obsolete_layers: list[str] = []
    for mod_root in mod_roots:
        numeric = sorted(
            (
                child
                for child in mod_root.iterdir()
                if child.is_dir()
                and VERSION_RE.fullmatch(child.name)
                and version_tuple(child.name) <= TARGET
            ),
            key=lambda path: version_tuple(path.name),
        )
        if len(numeric) > 1:
            obsolete_layers.extend(str(path.relative_to(repo)) for path in numeric[:-1])
    errors.extend(
        {"kind": "obsolete_version_layer", "path": path}
        for path in obsolete_layers
    )

    junk_files = [
        str(path.relative_to(repo))
        for path in repo.rglob("*")
        if path.is_file()
        and (
            path.suffix.casefold() in {".psd", ".bak"}
            or path.name.endswith(".txt(needfix)")
            or path.name.endswith(".incompatibleGun'sElevatormod")
        )
    ]
    errors.extend(
        {"kind": "development_artifact", "path": path} for path in junk_files
    )

    report = {
        "target": "Project Zomboid 42.20.0",
        "mod_roots": len(mod_roots),
        "active_manifests": len(selected),
        "active_ids": len(active_ids),
        "server_mods": len(server_mods),
        "repository_workshop_items": repository_workshop_items,
        "server_workshop_items": server_workshop_items,
        "server_map": server_map,
        "json_files": len(json_files),
        "invalid_json": len(invalid_json),
        "obsolete_version_layers": len(obsolete_layers),
        "development_artifacts": len(junk_files),
        "errors": errors,
        "warnings": warnings,
        "mods": selected,
    }
    report_path = (
        (repo / args.report).resolve() if not args.report.is_absolute() else args.report
    )
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(
        json.dumps(
            {key: value for key, value in report.items() if key != "mods"},
            ensure_ascii=False,
            indent=2,
        )
    )
    print(f"Informe: {report_path}")
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
