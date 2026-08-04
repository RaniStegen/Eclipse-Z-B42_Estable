#!/usr/bin/env python3
"""Genera y compara manifiestos SHA-256 del modpack desplegado.

Ejemplos:
  python generar_manifest_despliegue.py MODPACK-ACTUAL-EN-SERVIDOR --output github.json
  python generar_manifest_despliegue.py /ruta/workshop/content/108600 --output servidor.json
  python generar_manifest_despliegue.py --compare github.json servidor.json --output comparacion.json
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
from typing import Any

VERSION_RE = re.compile(r"^\d+(?:\.\d+)*$")


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser()
    p.add_argument("source", nargs="?", type=Path)
    p.add_argument("--output", required=True, type=Path)
    p.add_argument("--config", type=Path, default=Path(__file__).with_name("configuracion_servidor_actual.json"))
    p.add_argument("--compare", nargs=2, type=Path, metavar=("MANIFEST_A", "MANIFEST_B"))
    return p.parse_args()


def sha_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as fh:
        for block in iter(lambda: fh.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def read_text(path: Path) -> str:
    raw = path.read_bytes()
    for enc in ("utf-8-sig", "utf-16", "cp1252"):
        try:
            return raw.decode(enc)
        except UnicodeError:
            pass
    return raw.decode("utf-8", errors="replace")


def mod_id_from_root(root: Path) -> str | None:
    infos = []
    direct = [root / "mod.info", root / "common" / "mod.info"]
    direct += sorted(root.glob("*/mod.info"), key=lambda p: p.parent.name)
    for info in direct:
        if not info.is_file():
            continue
        for raw in read_text(info).splitlines():
            line = raw.strip()
            if line.startswith("id="):
                infos.append(line.split("=", 1)[1].strip())
                break
    ids = {x for x in infos if x}
    return next(iter(ids)) if len(ids) == 1 else None


def discover_mod_roots(source: Path) -> dict[str, Path]:
    candidates: set[Path] = set()
    for info in source.rglob("mod.info"):
        parts = info.relative_to(source).parts
        if "media" in {p.lower() for p in parts}:
            continue
        parent = info.parent
        if parent.name == "common" or VERSION_RE.fullmatch(parent.name):
            candidates.add(parent.parent)
        else:
            candidates.add(parent)
    result: dict[str, Path] = {}
    for root in sorted(candidates):
        mod_id = mod_id_from_root(root)
        if mod_id and mod_id not in result:
            result[mod_id] = root
    return result


def make_manifest(source: Path, config: dict[str, Any]) -> dict[str, Any]:
    expected = [str(x) for x in config.get("mods", [])]
    external = {str(x) for x in config.get("external_mods", [])}
    roots = discover_mod_roots(source)
    mods: dict[str, Any] = {}
    for mod_id in expected:
        if mod_id in external:
            mods[mod_id] = {"scope": "external", "present": mod_id in roots}
            continue
        root = roots.get(mod_id)
        if root is None:
            mods[mod_id] = {"scope": "internal", "present": False}
            continue
        files = {}
        aggregate = hashlib.sha256()
        for path in sorted(p for p in root.rglob("*") if p.is_file()):
            rel = path.relative_to(root).as_posix()
            digest = sha_file(path)
            size = path.stat().st_size
            files[rel] = {"size": size, "sha256": digest}
            aggregate.update(rel.encode("utf-8"))
            aggregate.update(b"\0")
            aggregate.update(str(size).encode("ascii"))
            aggregate.update(b"\0")
            aggregate.update(digest.encode("ascii"))
            aggregate.update(b"\n")
        mods[mod_id] = {
            "scope": "internal",
            "present": True,
            "root": root.as_posix(),
            "file_count": len(files),
            "aggregate_sha256": aggregate.hexdigest(),
            "files": files,
        }
    return {
        "schema": 1,
        "build": str(config.get("build", "")),
        "source": source.resolve().as_posix(),
        "mods_order": expected,
        "mods": mods,
    }


def compare(a: dict[str, Any], b: dict[str, Any]) -> dict[str, Any]:
    ids = list(dict.fromkeys(list(a.get("mods_order", [])) + list(b.get("mods_order", []))))
    results = {}
    errors = 0
    for mod_id in ids:
        ma = a.get("mods", {}).get(mod_id)
        mb = b.get("mods", {}).get(mod_id)
        if not ma or not mb:
            errors += 1
            results[mod_id] = {"status": "missing-manifest-entry", "a": bool(ma), "b": bool(mb)}
            continue
        if ma.get("scope") == "external" or mb.get("scope") == "external":
            results[mod_id] = {"status": "external", "a_present": ma.get("present"), "b_present": mb.get("present")}
            continue
        if not ma.get("present") or not mb.get("present"):
            errors += 1
            results[mod_id] = {"status": "missing", "a_present": ma.get("present"), "b_present": mb.get("present")}
            continue
        if ma.get("aggregate_sha256") == mb.get("aggregate_sha256"):
            results[mod_id] = {"status": "identical", "sha256": ma.get("aggregate_sha256"), "file_count": ma.get("file_count")}
            continue
        files_a = ma.get("files", {})
        files_b = mb.get("files", {})
        names = sorted(set(files_a) | set(files_b))
        missing_a = [n for n in names if n not in files_a]
        missing_b = [n for n in names if n not in files_b]
        changed = [n for n in names if n in files_a and n in files_b and files_a[n].get("sha256") != files_b[n].get("sha256")]
        errors += 1
        results[mod_id] = {
            "status": "different",
            "a_sha256": ma.get("aggregate_sha256"),
            "b_sha256": mb.get("aggregate_sha256"),
            "missing_in_a": missing_a,
            "missing_in_b": missing_b,
            "changed": changed,
        }
    return {"schema": 1, "errors": errors, "mods": results}


def main() -> int:
    args = parse_args()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    if args.compare:
        a = json.loads(args.compare[0].read_text(encoding="utf-8-sig"))
        b = json.loads(args.compare[1].read_text(encoding="utf-8-sig"))
        result = compare(a, b)
        args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(f"Comparación: {result['errors']} diferencias internas")
        return 1 if result["errors"] else 0
    if args.source is None:
        raise SystemExit("Debe indicarse source o --compare.")
    config = json.loads(args.config.read_text(encoding="utf-8-sig"))
    result = make_manifest(args.source.resolve(), config)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    missing = [m for m, data in result["mods"].items() if data.get("scope") == "internal" and not data.get("present")]
    print(f"Manifiesto: {len(result['mods'])} IDs, {len(missing)} internos ausentes")
    return 1 if missing else 0


if __name__ == "__main__":
    raise SystemExit(main())
