#!/usr/bin/env python3
"""Consolida los ItemName.json ES de todos los mods del repositorio.

Evita que un ItemName.json global parcial oculte nombres que sí estaban
traducidos dentro del mod original. Las correcciones ya existentes en el
paquete global conservan prioridad, pero se rellenan todas sus ausencias.
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Dict, Iterable, Tuple

DEFAULT_TARGET = Path(
    "ECZTraducciones/Contents/mods/ECZ_Mods/42.18/"
    "media/lua/shared/Translate/ES/ItemName.json"
)
BAD_AUTHENTICZ_KEY = (
    "CEDA of 3 colors "
    "ItemName_AuthenticZClothing.Bag_SchoolBagCEDABlack"
)
GOOD_AUTHENTICZ_KEY = "AuthenticZClothing.Bag_SchoolBagCEDABlack"


def load_object(path: Path) -> Dict[str, str]:
    try:
        raw = json.loads(path.read_text(encoding="utf-8-sig"))
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        raise RuntimeError(f"No se pudo leer JSON válido: {path}: {exc}") from exc
    if not isinstance(raw, dict):
        raise RuntimeError(f"La raíz debe ser un objeto JSON: {path}")
    result: Dict[str, str] = {}
    for key, value in raw.items():
        if not isinstance(key, str) or not isinstance(value, str):
            raise RuntimeError(
                f"Todas las claves y valores deben ser texto: {path}: {key!r}"
            )
        result[key] = value
    return result


def normalise_known_errors(data: Dict[str, str]) -> Dict[str, str]:
    data = dict(data)
    if BAD_AUTHENTICZ_KEY in data:
        data.setdefault(GOOD_AUTHENTICZ_KEY, data[BAD_AUTHENTICZ_KEY])
        del data[BAD_AUTHENTICZ_KEY]
    return data


def iter_source_files(root: Path, target: Path) -> Iterable[Path]:
    target_resolved = target.resolve()
    for path in sorted(root.rglob("ItemName.json"), key=lambda p: p.as_posix().casefold()):
        if path.resolve() == target_resolved:
            continue
        normalised = path.as_posix().replace("\\", "/").casefold()
        if "/translate/es/itemname.json" not in normalised:
            continue
        if any(part in {".git", "__pycache__"} for part in path.parts):
            continue
        yield path


def merge_sources(root: Path, target: Path) -> Tuple[Dict[str, str], int, int]:
    merged: Dict[str, str] = {}
    origins: Dict[str, Path] = {}
    conflicts = 0
    files = 0
    for source in iter_source_files(root, target):
        files += 1
        data = normalise_known_errors(load_object(source))
        for key, value in data.items():
            if key in merged and merged[key] != value:
                conflicts += 1
                print(
                    f"AVISO: traducción distinta para {key!r}: "
                    f"{origins[key]} -> {source}",
                    file=sys.stderr,
                )
            merged[key] = value
            origins[key] = source
    if target.exists():
        merged.update(normalise_known_errors(load_object(target)))
    return merged, files, conflicts


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Consolida todos los ItemName.json ES-ES en el paquete global."
    )
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--target", type=Path, default=DEFAULT_TARGET)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    root = args.root.resolve()
    target = args.target if args.target.is_absolute() else root / args.target
    if not root.is_dir():
        print(f"ERROR: no existe la raíz: {root}", file=sys.stderr)
        return 2
    try:
        merged, files, conflicts = merge_sources(root, target)
    except RuntimeError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1
    if files == 0:
        print("ERROR: no se encontró ningún ItemName.json de Translate/ES.", file=sys.stderr)
        return 1

    rendered = json.dumps(
        dict(sorted(merged.items(), key=lambda pair: pair[0].casefold())),
        ensure_ascii=False,
        indent=4,
    ) + "\n"
    changed = not target.exists() or target.read_text(encoding="utf-8-sig") != rendered
    print(f"Archivos ES leídos: {files}")
    print(f"Entradas consolidadas: {len(merged)}")
    print(f"Conflictos informados: {conflicts}")
    print(f"Destino: {target}")
    print(f"Cambios pendientes: {'sí' if changed else 'no'}")
    if args.check:
        return 0
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(rendered, encoding="utf-8", newline="\n")
    print("ItemName.json global actualizado correctamente.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
