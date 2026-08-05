#!/usr/bin/env python3
"""Auditor enfocado del modpack Eclipse-Z B42.20.

Solo informa de problemas que pueden afectar a la carga del servidor, la
sincronización cliente-servidor o la interfaz. No modifica ningún archivo.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from collections import defaultdict
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any, Iterable


MOJIBAKE = ("Ã", "Â", "â", "ð", "�")
VERSION_RE = re.compile(r"^\d+(?:\.\d+)*$")
MODULE_RE = re.compile(r"\bmodule\s+([A-Za-z0-9_.-]+)")
ENTITY_RE = re.compile(r"\bentity\s+([A-Za-z0-9_.-]+)")
DEPENDENCY_KEYS = ("require", "requires", "requiredMods")
SENSITIVE_PATHS = {
    "media/lua/client/chat/ischat.lua",
    "media/registries.lua",
    "media/clothing/clothing.xml",
    "media/fileguidtable.xml",
    "media/sandbox-options.txt",
}


@dataclass
class Finding:
    severity: str
    code: str
    message: str
    path: str | None = None
    details: dict[str, Any] | None = None


class DuplicateKeyError(ValueError):
    pass


def args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "root",
        nargs="?",
        type=Path,
        default=Path(__file__).resolve().parents[1],
    )
    parser.add_argument(
        "--config",
        type=Path,
        default=Path(__file__).with_name("configuracion_servidor_actual.json"),
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(__file__).with_name("resultado_auditoria"),
    )
    return parser.parse_args()


def rel(path: Path, root: Path) -> str:
    return path.relative_to(root).as_posix()


def parse_kv(path: Path) -> dict[str, list[str]]:
    result: dict[str, list[str]] = defaultdict(list)
    text = path.read_text(encoding="utf-8-sig")
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith(("#", "--")) or "=" not in line:
            continue
        key, value = line.split("=", 1)
        result[key.strip()].append(value.strip())
    return dict(result)


def split_values(values: Iterable[str]) -> list[str]:
    output: list[str] = []
    for value in values:
        for part in re.split(r"[;,]", value):
            clean = part.strip()
            if clean:
                output.append(clean)
    return output


def unique_json_object(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    duplicates: list[str] = []
    for key, value in pairs:
        if key in result:
            duplicates.append(key)
        result[key] = value
    if duplicates:
        raise DuplicateKeyError(", ".join(sorted(set(duplicates))[:25]))
    return result


def read_json(path: Path) -> Any:
    return json.loads(
        path.read_text(encoding="utf-8-sig"),
        object_pairs_hook=unique_json_object,
    )


def walk_strings(value: Any, key_path: str = "") -> Iterable[tuple[str, str]]:
    if isinstance(value, dict):
        for key, child in value.items():
            path = f"{key_path}.{key}" if key_path else str(key)
            yield from walk_strings(child, path)
    elif isinstance(value, list):
        for index, child in enumerate(value):
            yield from walk_strings(child, f"{key_path}[{index}]")
    elif isinstance(value, str):
        yield key_path, value


def mod_roots(root: Path) -> list[Path]:
    found: list[Path] = []
    for mods_dir in sorted(root.glob("*/Contents/mods")):
        if mods_dir.is_dir():
            found.extend(sorted(path for path in mods_dir.iterdir() if path.is_dir()))
    return found


def mod_infos(mod_root: Path) -> list[Path]:
    return [
        path
        for path in sorted(mod_root.rglob("mod.info"))
        if "media" not in {part.lower() for part in path.parts}
    ]


def version_key(name: str) -> tuple[int, ...]:
    return tuple(int(part) for part in name.split(".")) if VERSION_RE.fullmatch(name) else (-1,)


def active_info(mod_root: Path, infos: list[Path]) -> Path | None:
    direct = mod_root / "mod.info"
    if direct in infos:
        return direct
    versioned: list[tuple[tuple[int, ...], Path]] = []
    for info in infos:
        parent = info.relative_to(mod_root).parent
        if len(parent.parts) == 1 and VERSION_RE.fullmatch(parent.name):
            versioned.append((version_key(parent.name), info))
    if versioned:
        return max(versioned, key=lambda item: item[0])[1]
    return infos[0] if infos else None


def virtual_path(path: Path) -> str | None:
    parts = [part.lower() for part in path.parts]
    try:
        index = parts.index("media")
    except ValueError:
        return None
    return "/".join(parts[index:])


def translation_dir(root: Path, wanted_id: str) -> Path | None:
    choices: list[tuple[tuple[int, ...], Path]] = []
    for mod_root in mod_roots(root):
        ids: set[str] = set()
        for info in mod_infos(mod_root):
            ids.update(parse_kv(info).get("id", []))
        if wanted_id not in ids:
            continue
        for directory in mod_root.rglob("Translate/ES"):
            relative = directory.relative_to(mod_root)
            version = next((part for part in relative.parts if VERSION_RE.fullmatch(part)), "0")
            choices.append((version_key(version), directory))
    return max(choices, key=lambda item: item[0])[1] if choices else None


def translation_maps(directory: Path) -> dict[str, dict[str, Any]]:
    output: dict[str, dict[str, Any]] = {}
    for path in sorted(directory.glob("*.json")):
        try:
            data = read_json(path)
        except (OSError, UnicodeDecodeError, json.JSONDecodeError, DuplicateKeyError):
            continue
        if isinstance(data, dict):
            output[path.name.lower()] = data
    return output


def audit(root: Path, config: dict[str, Any]) -> tuple[list[Finding], dict[str, int]]:
    findings: list[Finding] = []
    external_mods = {str(value) for value in config.get("external_mods", [])}
    external_workshop_items = {
        str(item.get("id")) if isinstance(item, dict) else str(item)
        for item in config.get("external_workshop_items", [])
    }
    stats = {
        "workshop_items": 0,
        "mod_directories": 0,
        "mod_ids": 0,
        "json_files": 0,
        "spanish_translation_json": 0,
        "sensitive_overrides": 0,
        "external_mods": len(external_mods),
        "external_workshop_items": len(external_workshop_items),
    }

    # Workshop Items.
    workshops: dict[str, list[Path]] = defaultdict(list)
    for path in sorted(root.glob("*/workshop.txt")):
        try:
            ids = parse_kv(path).get("id", [])
        except UnicodeDecodeError as exc:
            findings.append(Finding("error", "WORKSHOP_ENCODING", str(exc), rel(path, root)))
            continue
        if len(ids) != 1:
            findings.append(Finding("error", "WORKSHOP_ID_INVALID", "workshop.txt debe declarar un único id", rel(path, root), {"ids": ids}))
            continue
        workshops[ids[0]].append(path)
    stats["workshop_items"] = sum(len(paths) for paths in workshops.values())

    for item_id in map(str, config.get("workshop_items", [])):
        if item_id not in workshops and item_id not in external_workshop_items:
            findings.append(Finding("error", "WORKSHOP_ITEM_MISSING", f"Falta el Workshop Item interno {item_id}"))
    for item_id, paths in workshops.items():
        if len(paths) > 1:
            findings.append(Finding("error", "WORKSHOP_ID_DUPLICATED", f"El Workshop ID {item_id} está duplicado", details={"paths": [rel(path, root) for path in paths]}))

    # Mod IDs and dependencies.
    roots = mod_roots(root)
    stats["mod_directories"] = len(roots)
    ids_to_roots: dict[str, list[Path]] = defaultdict(list)
    dependencies: dict[str, set[str]] = defaultdict(set)
    owners: dict[Path, str] = {}

    for mod_root in roots:
        infos = mod_infos(mod_root)
        if not infos:
            findings.append(Finding("error", "MOD_INFO_MISSING", "Carpeta de mod sin mod.info", rel(mod_root, root)))
            continue
        declared: set[str] = set()
        for info in infos:
            try:
                parsed = parse_kv(info)
            except UnicodeDecodeError as exc:
                findings.append(Finding("error", "MOD_INFO_ENCODING", str(exc), rel(info, root)))
                continue
            ids = parsed.get("id", [])
            if len(ids) != 1:
                findings.append(Finding("error", "MOD_ID_INVALID", "mod.info debe declarar un único id", rel(info, root), {"ids": ids}))
                continue
            mod_id = ids[0]
            declared.add(mod_id)
            for key in DEPENDENCY_KEYS:
                dependencies[mod_id].update(split_values(parsed.get(key, [])))
        if len(declared) > 1:
            findings.append(Finding("error", "MOD_ID_INCONSISTENT", "Una carpeta declara IDs distintos según la versión", rel(mod_root, root), {"ids": sorted(declared)}))
        for mod_id in declared:
            ids_to_roots[mod_id].append(mod_root)
        info = active_info(mod_root, infos)
        owners[mod_root] = next(iter(declared), mod_root.name)
        if "ECZ_10" in declared and not (mod_root / "mod.info").exists():
            findings.append(Finding("error", "ECZ10_ROOT_MOD_INFO_MISSING", "ECZ_10 no tiene mod.info en la raíz", rel(mod_root, root)))
        if info is None:
            findings.append(Finding("error", "ACTIVE_MOD_INFO_MISSING", "No se pudo determinar el mod.info activo", rel(mod_root, root)))

    stats["mod_ids"] = len(ids_to_roots)
    for mod_id, paths in ids_to_roots.items():
        if len(paths) > 1:
            findings.append(Finding("error", "MOD_ID_DUPLICATED", f"El ID {mod_id} existe en varias carpetas", details={"paths": [rel(path, root) for path in paths]}))

    expected_mods = [str(value) for value in config.get("mods", [])]
    for mod_id in expected_mods:
        if mod_id not in ids_to_roots and mod_id not in external_mods:
            findings.append(Finding("error", "SERVER_MOD_MISSING", f"Mods= contiene {mod_id}, pero ese ID interno no está en el modpack"))

    required_tail = [str(value) for value in config.get("required_tail_order", [])]
    if required_tail and expected_mods[-len(required_tail):] != required_tail:
        findings.append(Finding("error", "MOD_ORDER_TAIL_INVALID", "El final de Mods= es incorrecto", details={"expected": required_tail, "actual": expected_mods[-len(required_tail):]}))

    all_ids = set(ids_to_roots) | external_mods
    for mod_id, required in dependencies.items():
        for dependency in required:
            if dependency not in all_ids:
                findings.append(Finding("error", "REQUIRED_MOD_MISSING", f"{mod_id} requiere {dependency}, pero ese ID no existe"))

    # Map folder.
    map_folder = str(config.get("map_folder", "")).strip()
    if map_folder and not any(path.is_dir() for path in root.rglob(map_folder)):
        findings.append(Finding("error", "MAP_FOLDER_MISSING", f"No se encontró la carpeta de mapa {map_folder}"))

    # JSON, translations, entities and backups.
    sensitive_owners: dict[str, set[str]] = defaultdict(set)
    entities: dict[str, list[str]] = defaultdict(list)

    for mod_root in roots:
        owner = owners.get(mod_root, mod_root.name)
        for path in mod_root.rglob("*"):
            if not path.is_file():
                continue

            lower_name = path.name.lower()
            if ".bak" in lower_name or lower_name.endswith((".backup", ".disabled")):
                findings.append(Finding("warning", "BACKUP_FILE_ACTIVE", "Archivo de copia dentro de Contents", rel(path, root)))

            virtual = virtual_path(path)
            if virtual in SENSITIVE_PATHS:
                sensitive_owners[virtual].add(owner)

            if path.suffix.lower() == ".json":
                stats["json_files"] += 1
                try:
                    data = read_json(path)
                except UnicodeDecodeError as exc:
                    findings.append(Finding("error", "JSON_ENCODING_INVALID", f"JSON no es UTF-8: {exc}", rel(path, root)))
                    continue
                except DuplicateKeyError as exc:
                    findings.append(Finding("error", "JSON_DUPLICATE_KEYS", f"Claves duplicadas: {exc}", rel(path, root)))
                    continue
                except json.JSONDecodeError as exc:
                    findings.append(Finding("error", "JSON_INVALID", f"Línea {exc.lineno}, columna {exc.colno}: {exc.msg}", rel(path, root)))
                    continue

                normalized = path.as_posix().lower()
                if "/translate/es/" in normalized:
                    stats["spanish_translation_json"] += 1
                    for key_path, text in walk_strings(data):
                        broken = [token for token in MOJIBAKE if token in text]
                        if broken:
                            findings.append(Finding("error", "TRANSLATION_MOJIBAKE", f"Codificación dañada en {key_path}", rel(path, root), {"value": text[:300], "tokens": broken}))
                    if isinstance(data, dict) and "UI_servers_refresh_timer" in data:
                        value = str(data["UI_servers_refresh_timer"])
                        if value != "REFRESCAR %1":
                            findings.append(Finding("error", "MULTIPLAYER_REFRESH_FORMAT", "UI_servers_refresh_timer debe ser exactamente REFRESCAR %1", rel(path, root), {"value": value}))

            normalized = path.as_posix().lower()
            if path.suffix.lower() in {".txt", ".lua"} and "/media/scripts/" in normalized:
                text = path.read_text(encoding="utf-8-sig", errors="ignore")
                module_match = MODULE_RE.search(text)
                module = module_match.group(1) if module_match else "?"
                for match in ENTITY_RE.finditer(text):
                    entities[f"{module}.{match.group(1)}"].append(rel(path, root))

    for virtual, mod_ids in sensitive_owners.items():
        if len(mod_ids) > 1:
            stats["sensitive_overrides"] += 1
            findings.append(Finding("warning", "SENSITIVE_FILE_OVERRIDDEN", f"La ruta sensible {virtual} es aportada por varios mods", details={"mods": sorted(mod_ids)}))

    for entity, paths in entities.items():
        unique = sorted(set(paths))
        if len(unique) > 1:
            findings.append(Finding("error", "ENTITY_DUPLICATED", f"La entidad {entity} está definida varias veces", details={"paths": unique}))

    # Overlap between base and mod translations.
    base_dir = translation_dir(root, "ECZ_Idioma")
    mods_dir = translation_dir(root, "ECZ_Mods")
    if base_dir and mods_dir:
        base_maps = translation_maps(base_dir)
        mods_maps = translation_maps(mods_dir)
        overlap = 0
        conflicts = 0
        samples: list[dict[str, Any]] = []
        for filename in sorted(set(base_maps) & set(mods_maps)):
            common = sorted(set(base_maps[filename]) & set(mods_maps[filename]))
            overlap += len(common)
            for key in common:
                if base_maps[filename][key] != mods_maps[filename][key]:
                    conflicts += 1
                    if len(samples) < 20:
                        samples.append({"file": filename, "key": key, "base": base_maps[filename][key], "mods": mods_maps[filename][key]})
        if overlap:
            findings.append(Finding("warning", "BASE_MOD_TRANSLATION_OVERLAP", f"ECZ_Mods comparte {overlap} claves con ECZ_Idioma; {conflicts} valores son distintos", details={"samples": samples}))

    return findings, stats


def markdown(root: Path, config: dict[str, Any], findings: list[Finding], stats: dict[str, int]) -> str:
    counts = defaultdict(int)
    for finding in findings:
        counts[finding.severity] += 1
    lines = [
        "# Auditoría enfocada del modpack Eclipse-Z",
        "",
        f"- Build: `{config.get('build', 'desconocida')}`",
        f"- Errores: **{counts['error']}**",
        f"- Advertencias: **{counts['warning']}**",
        f"- Dependencias externas excluidas del contenido interno: **{len(config.get('external_mods', []))}**",
        "",
        "## Estadísticas",
        "",
    ]
    lines.extend(f"- `{key}`: {value}" for key, value in stats.items())
    lines.extend(["", "## Hallazgos", ""])
    order = {"error": 0, "warning": 1, "info": 2}
    if not findings:
        lines.append("No se encontraron problemas.")
    for finding in sorted(findings, key=lambda item: (order.get(item.severity, 9), item.code, item.path or "")):
        icon = "❌" if finding.severity == "error" else "⚠️"
        lines.extend([f"### {icon} `{finding.code}`", "", finding.message])
        if finding.path:
            lines.extend(["", f"Ruta: `{finding.path}`"])
        if finding.details:
            lines.extend(["", "```json", json.dumps(finding.details, ensure_ascii=False, indent=2), "```"])
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    options = args()
    root = options.root.resolve()
    config_path = options.config.resolve()
    output = options.output.resolve()
    try:
        config = json.loads(config_path.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"No se pudo leer la configuración: {exc}", file=sys.stderr)
        return 2

    findings, stats = audit(root, config)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.with_suffix(".json").write_text(
        json.dumps({"root": str(root), "stats": stats, "findings": [asdict(item) for item in findings]}, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    output.with_suffix(".md").write_text(markdown(root, config, findings, stats), encoding="utf-8")
    errors = sum(item.severity == "error" for item in findings)
    warnings = sum(item.severity == "warning" for item in findings)
    print(f"Auditoría enfocada terminada: {errors} errores, {warnings} advertencias")
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
