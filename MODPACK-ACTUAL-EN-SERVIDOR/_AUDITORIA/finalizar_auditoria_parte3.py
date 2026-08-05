#!/usr/bin/env python3
"""Convierte el análisis bruto de la Parte 3 en un resultado efectivo.

El auditor bruto muestra todas las asignaciones incompatibles encontradas en
los mods de origen. Este finalizador comprueba si cada conflicto está resuelto
por un parche posterior en `ECZ2_Ajustes`, y sustituye los falsos positivos de
outfits hombre/mujer por el diagnóstico estructural sensible al género.
"""
from __future__ import annotations

import argparse
import json
import re
from collections import Counter
from pathlib import Path
from typing import Any

LATE_PATCH_NAMES = {
    "zz_ecz_compat_recetas_etiquetas.txt",
    "zz_ecz_compat_propiedades_parte3.txt",
}
CLOTHING_RAW_CODES = {
    "CLOTHING_OUTFIT_DUPLICATED_IN_FILE",
    "CLOTHING_GUID_DUPLICATED_IN_FILE",
    "CLOTHING_OUTFIT_NAME_CONFLICT",
    "CLOTHING_OUTFIT_GUID_CONFLICT",
}
GUID_RAW_CODES = {
    "FILEGUID_PATH_CONFLICT",
    "FILEGUID_GUID_CONFLICT",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--raw", required=True, type=Path)
    parser.add_argument("--guid", required=True, type=Path)
    parser.add_argument("--config", type=Path, default=Path(__file__).with_name("configuracion_servidor_actual.json"))
    parser.add_argument("--compat", type=Path, default=Path(__file__).with_name("COMPAT_RECETAS_ETIQUETAS.json"))
    parser.add_argument("--output", required=True, type=Path)
    return parser.parse_args()


def source_position(source: dict[str, Any], positions: dict[str, int]) -> int:
    return positions.get(str(source.get("mod", "")), -1)


def late_patch_source(source: dict[str, Any]) -> bool:
    path = str(source.get("path", "")).replace("\\", "/").lower()
    return (
        str(source.get("mod", "")) == "ECZ2_Ajustes"
        and Path(path).name in LATE_PATCH_NAMES
    )


def conflict_is_resolved(finding: dict[str, Any], positions: dict[str, int]) -> tuple[bool, dict[str, Any]]:
    sources = list((finding.get("details") or {}).get("sources") or [])
    late_sources = [source for source in sources if late_patch_source(source)]
    if not late_sources:
        return False, {"reason": "sin parche tardío"}

    latest_position = max((source_position(source, positions) for source in sources), default=-1)
    late_latest = max((source_position(source, positions) for source in late_sources), default=-1)
    if late_latest != latest_position:
        return False, {
            "reason": "existe una asignación posterior al parche",
            "latest_position": latest_position,
            "late_patch_position": late_latest,
        }

    distinct_late_values = {str(source.get("value", "")) for source in late_sources}
    if len(distinct_late_values) != 1:
        return False, {
            "reason": "el parche tardío asigna varios valores",
            "values": sorted(distinct_late_values),
        }

    match = re.match(r"(\S+) asigna valores distintos a (\S+)", str(finding.get("message", "")))
    return True, {
        "symbol": match.group(1) if match else None,
        "property": match.group(2) if match else None,
        "resolved_value": next(iter(distinct_late_values)),
        "patches": [source.get("path") for source in late_sources],
    }


def diagnostic_errors(guid: dict[str, Any]) -> list[dict[str, Any]]:
    output = []
    mappings = (
        ("GUID_PATH_CONFLICT_FINAL", "path_conflicts", "Persisten rutas con GUID distintos."),
        ("GUID_REUSED_FOR_FILES_FINAL", "guid_conflicts", "Persisten GUID asignados a varias rutas."),
        ("OUTFIT_GUID_CONFLICT_FINAL", "outfit_guid_conflicts", "Persisten GUID compartidos por outfits distintos."),
        ("OUTFIT_NAME_DUPLICATED_SAME_GENDER", "duplicate_outfit_names_same_gender", "Hay nombres de outfit repetidos dentro del mismo género."),
        ("OUTFIT_GUID_DUPLICATED_SAME_GENDER", "duplicate_outfit_guids_same_gender", "Hay GUID de outfit repetidos dentro del mismo género."),
    )
    for code, key, message in mappings:
        entries = guid.get(key) or {}
        if entries:
            output.append({
                "severity": "error",
                "code": code,
                "message": message,
                "path": None,
                "mod_id": None,
                "details": {"count": len(entries), "entries": entries},
            })
    return output


def markdown(result: dict[str, Any]) -> str:
    stats = result["stats"]
    resolved = result["resolved"]
    findings = result["findings"]
    guid_summary = result["guid_summary"]
    compat_summary = result["compat_summary"]

    lines = [
        "# Parte 3 final — conflictos globales y preparación de runtime",
        "",
        f"Build: **{stats.get('build', 'desconocida')}**",
        "",
        "## Resultado efectivo",
        "",
        f"- Errores no resueltos: **{stats['errors']}**",
        f"- Advertencias: **{stats['warnings']}**",
        f"- Conflictos brutos resueltos por parches tardíos: **{len(resolved)}**",
        f"- Parches de recetas/etiquetas generados: **{compat_summary.get('items', 0)} objetos**",
        "",
        "## GUID y outfits",
        "",
    ]
    for key, value in guid_summary.items():
        lines.append(f"- `{key}`: {value}")

    lines.extend([
        "",
        "## Resoluciones aplicadas",
        "",
    ])
    resolved_counts = Counter(entry.get("property") or "desconocida" for entry in resolved)
    if not resolved_counts:
        lines.append("No fue necesario resolver conflictos mediante parches tardíos.")
    for property_name, count in sorted(resolved_counts.items()):
        lines.append(f"- `{property_name}`: {count}")

    lines.extend([
        "",
        "## Hallazgos pendientes",
        "",
    ])
    if not findings:
        lines.append("No quedan errores ni advertencias estáticas pendientes.")
    for finding in findings:
        icon = "❌" if finding["severity"] == "error" else "⚠️"
        lines.extend([
            f"### {icon} `{finding['code']}`",
            "",
            finding["message"],
        ])
        if finding.get("mod_id"):
            lines.extend(["", f"Mod: `{finding['mod_id']}`"])
        if finding.get("path"):
            lines.extend(["", f"Ruta: `{finding['path']}`"])
        if finding.get("details"):
            lines.extend([
                "",
                "```json",
                json.dumps(finding["details"], ensure_ascii=False, indent=2),
                "```",
            ])
        lines.append("")

    lines.extend([
        "## Interpretación",
        "",
        "Los conflictos de `EvolvedRecipe`, `Tags` y propiedades no acumulables se consideran resueltos únicamente cuando `ECZ2_Ajustes` contiene la asignación final y no existe otro proveedor posterior en `Mods=`.",
        "",
        "La única advertencia esperada tras una auditoría limpia es el reemplazo completo de `ISChat.lua` por `ECZChat`. Requiere prueba funcional y comparación con el archivo vanilla después de cada actualización del juego.",
        "",
        "La igualdad entre GitHub, Workshop, servidor dedicado y clientes no puede demostrarse solo con el repositorio. Se verifica con `generar_manifest_despliegue.py` y `validar_logs_runtime.py`.",
        "",
    ])
    return "\n".join(lines)


def main() -> int:
    args = parse_args()
    raw = json.loads(args.raw.read_text(encoding="utf-8-sig"))
    guid = json.loads(args.guid.read_text(encoding="utf-8-sig"))
    config = json.loads(args.config.read_text(encoding="utf-8-sig"))
    compat = json.loads(args.compat.read_text(encoding="utf-8-sig")) if args.compat.is_file() else {}

    positions = {str(mod_id): index for index, mod_id in enumerate(config.get("mods", []))}
    final_findings: list[dict[str, Any]] = []
    resolved: list[dict[str, Any]] = []

    for finding in raw.get("findings", []):
        code = str(finding.get("code", ""))
        if code == "SCRIPT_PROPERTY_CONFLICT":
            is_resolved, resolution = conflict_is_resolved(finding, positions)
            if is_resolved:
                resolved.append({
                    "code": code,
                    "message": finding.get("message"),
                    **resolution,
                })
                continue
        if code in CLOTHING_RAW_CODES or code in GUID_RAW_CODES:
            # El diagnóstico v2, que conoce género, nombre, ruta y GUID, es la
            # fuente de verdad para ropa. Sus errores se agregan más abajo.
            continue
        final_findings.append(finding)

    final_findings.extend(diagnostic_errors(guid))
    final_findings.sort(key=lambda item: (
        0 if item.get("severity") == "error" else 1,
        str(item.get("code", "")),
        str(item.get("path") or ""),
    ))

    raw_stats = dict(raw.get("stats") or {})
    guid_summary = dict(guid.get("summary") or {})
    result = {
        "stats": {
            **raw_stats,
            "raw_errors": int(raw_stats.get("errors", 0)),
            "raw_warnings": int(raw_stats.get("warnings", 0)),
            "resolved_conflicts": len(resolved),
            "errors": sum(item.get("severity") == "error" for item in final_findings),
            "warnings": sum(item.get("severity") == "warning" for item in final_findings),
        },
        "compat_summary": {
            "items": int(compat.get("items", 0)),
            "modules": compat.get("modules", {}),
            "target": compat.get("target"),
        },
        "guid_summary": guid_summary,
        "resolved": resolved,
        "findings": final_findings,
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.with_suffix(".json").write_text(
        json.dumps(result, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    args.output.with_suffix(".md").write_text(markdown(result), encoding="utf-8")

    print(
        "Parte 3 final: "
        f"{result['stats']['errors']} errores, "
        f"{result['stats']['warnings']} advertencias, "
        f"{result['stats']['resolved_conflicts']} conflictos resueltos"
    )
    return 1 if result["stats"]["errors"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
