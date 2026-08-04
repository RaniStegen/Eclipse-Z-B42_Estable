#!/usr/bin/env python3
"""Reparaciones seguras y deterministas para el modpack Eclipse-Z B42.20.

La herramienta trabaja sobre una copia/checkout del repositorio. Solo corrige
hallazgos conocidos y no toca partidas guardadas.
"""

from __future__ import annotations

import json
import re
import shutil
from pathlib import Path
from typing import Any


SCRIPT = Path(__file__).resolve()
MODPACK_ROOT = SCRIPT.parents[1]
REPO_ROOT = SCRIPT.parents[2]

EXPECTED_WORKSHOP = {
    "3755715727",
    "3739256725",
}

JSON_FIXES: dict[str, dict[str, str]] = {
    "ECZTraducciones/Contents/mods/ECZ_Mods/42.20.0/media/lua/shared/Translate/ES/UI.json": {
        "UI_KP_AdminResetPin": "Restablecer PIN → 0000",
        "UI_KP_AdminTitle": "PANEL DE ADMINISTRADOR — TECLADO",
        "UI_KP_LockTitle": "BLOQUEAR PUERTA — PIN",
        "UI_KP_RemoveTitle": "QUITAR TECLADO — PIN",
    },
    "ECZTraducciones/Contents/mods/ECZ_Mods/42.20.0/media/lua/shared/Translate/ES/ItemName.json": {
        "Spongie.Jumper_MilitaryROLL": "Suéter militar",
    },
    "EclipseZ - 1/Contents/mods/ECZ_11/42.15/media/lua/shared/Translate/ES/Sandbox.json": {
        "Sandbox_GydeTraitMags_SpawnHandy_tooltip": (
            "Desactivar impide su aparición en el mundo.\n\n"
            "Descripción del rasgo:\n"
            "+100 HP para todas las construcciones.\n"
            "Aumenta la velocidad de construcción aproximadamente un 11 %."
        ),
    },
    "EclipseZ - 2/Contents/mods/ECZ2_6/common/media/lua/shared/Translate/ES/IG_UI.json": {
        "IGUI_Hair_M_Goth": "Coletas góticas",
        "IGUI_Hair_M_RickShow": "Hacia atrás engominado",
        "IGUI_Hair_M_Yu": "Corte tazón",
        "IGUI_Hair_F_Goth2": "Coletas góticas",
        "IGUI_Hair_F_RickShow": "Hacia atrás engominado",
        "IGUI_Hair_F_Yu": "Corte tazón",
    },
    "EclipseZ - 2/Contents/mods/ECZ2_7.2/common/media/lua/shared/Translate/ES/ItemName.json": {
        "Base.Jacket_PoliceOPEN": "Chaqueta de policía (abierta)",
        "Base.Jacket_ArmyCamoDesertOPEN": "Chaqueta militar con camuflaje desértico (abierta)",
    },
}


def parse_simple_kv(path: Path) -> dict[str, str]:
    result: dict[str, str] = {}
    text = path.read_text(encoding="utf-8-sig", errors="replace")
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith(("#", "--")) or "=" not in line:
            continue
        key, value = line.split("=", 1)
        result[key.strip()] = value.strip()
    return result


def workshop_items_under(root: Path) -> dict[str, Path]:
    found: dict[str, Path] = {}
    for workshop in root.glob("*/workshop.txt"):
        item_id = parse_simple_kv(workshop).get("id")
        if item_id:
            found[item_id] = workshop.parent
    return found


def restore_missing_workshop_packages(changes: list[str]) -> None:
    current = workshop_items_under(MODPACK_ROOT)
    missing = EXPECTED_WORKSHOP - set(current)
    if not missing:
        return

    candidates: dict[str, list[Path]] = {item_id: [] for item_id in missing}
    for workshop in REPO_ROOT.rglob("workshop.txt"):
        if MODPACK_ROOT in workshop.parents:
            continue
        item_id = parse_simple_kv(workshop).get("id")
        if item_id in candidates:
            candidates[item_id].append(workshop.parent)

    for item_id in sorted(missing):
        choices = sorted(candidates[item_id], key=lambda p: (len(p.parts), p.as_posix()))
        if not choices:
            raise RuntimeError(f"No se encontró una copia fuente del Workshop Item {item_id}")
        source = choices[0]
        destination = MODPACK_ROOT / source.name
        if destination.exists():
            raise RuntimeError(f"No se puede restaurar {item_id}: ya existe {destination}")
        shutil.copytree(source, destination)
        changes.append(f"Restaurado Workshop Item {item_id}: {source.relative_to(REPO_ROOT)} → {destination.name}")


def read_json_any_encoding(path: Path) -> tuple[Any, str]:
    raw = path.read_bytes()
    if raw.startswith((b"\xff\xfe", b"\xfe\xff")):
        text = raw.decode("utf-16")
        return json.loads(text), "utf-16"
    text = raw.decode("utf-8-sig")
    return json.loads(text), "utf-8"


def write_json(path: Path, data: Any) -> None:
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def convert_non_utf8_json(changes: list[str]) -> None:
    for path in sorted(MODPACK_ROOT.rglob("*.json")):
        data, encoding = read_json_any_encoding(path)
        if encoding != "utf-8":
            write_json(path, data)
            changes.append(f"Convertido a UTF-8: {path.relative_to(MODPACK_ROOT)}")


def repair_dependency_value(value: str) -> str:
    parts = re.split(r"([;,])", value)
    for index in range(0, len(parts), 2):
        token = parts[index]
        leading = token[: len(token) - len(token.lstrip())]
        core = token.strip().lstrip("\\")
        trailing = token[len(token.rstrip()):] if token.rstrip() != token else ""
        parts[index] = f"{leading}{core}{trailing}"
    return "".join(parts)


def repair_mod_dependencies(changes: list[str]) -> None:
    dependency_keys = {"require", "requires", "requiredMods"}
    for path in sorted(MODPACK_ROOT.rglob("mod.info")):
        original = path.read_text(encoding="utf-8-sig", errors="strict")
        output: list[str] = []
        changed = False
        for raw in original.splitlines(keepends=True):
            ending = "\n" if raw.endswith("\n") else ""
            body = raw[:-1] if ending else raw
            if "=" not in body:
                output.append(raw)
                continue
            key, value = body.split("=", 1)
            if key.strip() not in dependency_keys:
                output.append(raw)
                continue
            repaired = repair_dependency_value(value)
            if repaired != value:
                changed = True
            output.append(f"{key}={repaired}{ending}")
        if changed:
            path.write_text("".join(output), encoding="utf-8")
            changes.append(f"Dependencia normalizada: {path.relative_to(MODPACK_ROOT)}")


def apply_known_json_fixes(changes: list[str]) -> None:
    for relative, replacements in JSON_FIXES.items():
        path = MODPACK_ROOT / relative
        if not path.exists():
            raise RuntimeError(f"Falta el archivo esperado para reparar: {relative}")
        data, _ = read_json_any_encoding(path)
        if not isinstance(data, dict):
            raise RuntimeError(f"El JSON no es un objeto: {relative}")
        changed_keys: list[str] = []
        for key, value in replacements.items():
            if key not in data:
                raise RuntimeError(f"Falta la clave {key} en {relative}")
            if data[key] != value:
                data[key] = value
                changed_keys.append(key)
        if changed_keys:
            write_json(path, data)
            changes.append(f"Traducción reparada: {relative} ({', '.join(changed_keys)})")

    # La corrección temporal deja de ser necesaria al quedar arreglados los
    # archivos de origen.
    temporary_override = (
        MODPACK_ROOT
        / "ECZTraducciones/Contents/mods/ECZ_Mods/42.20.0/media/lua/shared/Translate/ES/ZZZZ_ECZ_EncodingCorrections.json"
    )
    if temporary_override.exists():
        temporary_override.unlink()
        changes.append(f"Retirado override temporal: {temporary_override.relative_to(MODPACK_ROOT)}")


def enforce_multiplayer_placeholder(changes: list[str]) -> None:
    key = "UI_servers_refresh_timer"
    for path in sorted(MODPACK_ROOT.rglob("Translate/ES/*.json")):
        data, _ = read_json_any_encoding(path)
        if not isinstance(data, dict) or key not in data:
            continue
        if data[key] != "REFRESCAR %1":
            data[key] = "REFRESCAR %1"
            write_json(path, data)
            changes.append(f"Marcador multijugador corregido: {path.relative_to(MODPACK_ROOT)}")


def remove_safe_backups(changes: list[str]) -> None:
    for path in sorted(MODPACK_ROOT.rglob("*"), reverse=True):
        if not path.is_file():
            continue
        if ".bak" not in path.name.lower():
            continue
        path.unlink()
        changes.append(f"Copia .bak eliminada: {path.relative_to(MODPACK_ROOT)}")


def write_report(changes: list[str]) -> None:
    report = MODPACK_ROOT / "_AUDITORIA/REPARACIONES_APLICADAS.md"
    lines = [
        "# Reparaciones aplicadas automáticamente",
        "",
        "Estas operaciones son deterministas y no modifican partidas guardadas.",
        "",
    ]
    if changes:
        lines.extend(f"- {change}" for change in changes)
    else:
        lines.append("- No había cambios pendientes.")
    lines.append("")
    report.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    changes: list[str] = []
    restore_missing_workshop_packages(changes)
    repair_mod_dependencies(changes)
    convert_non_utf8_json(changes)
    apply_known_json_fixes(changes)
    enforce_multiplayer_placeholder(changes)
    remove_safe_backups(changes)
    write_report(changes)
    print(f"Reparaciones aplicadas: {len(changes)}")
    for change in changes:
        print(f"- {change}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
