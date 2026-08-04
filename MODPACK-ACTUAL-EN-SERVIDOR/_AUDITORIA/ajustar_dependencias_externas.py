#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def replace(path: Path, old: str, new: str) -> None:
    text = path.read_text(encoding="utf-8")
    if old not in text:
        raise RuntimeError(f"No se encontró el bloque esperado en {path}: {old[:80]!r}")
    path.write_text(text.replace(old, new, 1), encoding="utf-8")


def patch_general() -> None:
    path = ROOT / "auditar_modpack_v2.py"
    replace(
        path,
        'def audit(root: Path, config: dict[str, Any]) -> tuple[list[Finding], dict[str, int]]:\n    findings: list[Finding] = []\n',
        'def audit(root: Path, config: dict[str, Any]) -> tuple[list[Finding], dict[str, int]]:\n    findings: list[Finding] = []\n    external_mods = {str(value) for value in config.get("external_mods", [])}\n    external_workshop_items = {\n        str(item.get("id")) if isinstance(item, dict) else str(item)\n        for item in config.get("external_workshop_items", [])\n    }\n',
    )
    replace(
        path,
        '        "sensitive_overrides": 0,\n',
        '        "sensitive_overrides": 0,\n        "external_mods": len(external_mods),\n        "external_workshop_items": len(external_workshop_items),\n',
    )
    replace(
        path,
        '        if item_id not in workshops:\n            findings.append(Finding("error", "WORKSHOP_ITEM_MISSING", f"Falta el Workshop Item {item_id}"))\n',
        '        if item_id not in workshops and item_id not in external_workshop_items:\n            findings.append(Finding("error", "WORKSHOP_ITEM_MISSING", f"Falta el Workshop Item interno {item_id}"))\n',
    )
    replace(
        path,
        '        if mod_id not in ids_to_roots:\n            findings.append(Finding("error", "SERVER_MOD_MISSING", f"Mods= contiene {mod_id}, pero ese ID no está en el modpack"))\n',
        '        if mod_id not in ids_to_roots and mod_id not in external_mods:\n            findings.append(Finding("error", "SERVER_MOD_MISSING", f"Mods= contiene {mod_id}, pero ese ID interno no está en el modpack"))\n',
    )
    replace(
        path,
        '    all_ids = set(ids_to_roots)\n',
        '    all_ids = set(ids_to_roots) | external_mods\n',
    )
    replace(
        path,
        '        f"- Advertencias: **{counts[\'warning\']}**",\n',
        '        f"- Advertencias: **{counts[\'warning\']}**",\n        f"- Dependencias externas excluidas del contenido interno: **{len(config.get(\'external_mods\', []))}**",\n',
    )


def patch_part2() -> None:
    path = ROOT / "auditar_modinfo_versiones.py"
    replace(
        path,
        '    build=str(cfg["build"]); line=list(map(str,cfg["mods"])); tail=list(map(str,cfg.get("required_tail_order",[])))\n',
        '    build=str(cfg["build"]); line=list(map(str,cfg["mods"])); tail=list(map(str,cfg.get("required_tail_order",[]))); external=set(map(str,cfg.get("external_mods",[])))\n',
    )
    replace(
        path,
        '    for idx,m in enumerate(line,1):\n        if m in active_ids:continue\n',
        '    for idx,m in enumerate(line,1):\n        if m in active_ids or m in external:continue\n',
    )
    replace(
        path,
        '            if d not in active_ids:\n                actual=lower.get(d.lower())\n',
        '            if d not in active_ids and d not in external:\n                actual=lower.get(d.lower())\n',
    )
    replace(
        path,
        '    stats={"build":build,"mods_line":len(line),"packages":len({r["package"] for r in folders}),"folders":len(folders),"mod_info":sum(r["info_count"] for r in folders),"active_ids":len(active_ids),"version_folders":sum(len(r["versions"]) for r in folders),"errors":sum(f.severity=="error" for f in findings),"warnings":sum(f.severity=="warning" for f in findings),"recommended":recommended,"order_unchanged":recommended==line}\n',
        '    stats={"build":build,"mods_line":len(line),"packages":len({r["package"] for r in folders}),"folders":len(folders),"mod_info":sum(r["info_count"] for r in folders),"active_ids":len(active_ids),"external_ids":len(external),"version_folders":sum(len(r["versions"]) for r in folders),"errors":sum(f.severity=="error" for f in findings),"warnings":sum(f.severity=="warning" for f in findings),"recommended":recommended,"order_unchanged":recommended==line}\n',
    )
    replace(
        path,
        'def markdown(findings,folders,stats,cfg):\n    line=list(map(str,cfg["mods"])); byid={r["active_id"]:r for r in folders if r["active_id"]}\n',
        'def markdown(findings,folders,stats,cfg):\n    line=list(map(str,cfg["mods"])); external=set(map(str,cfg.get("external_mods",[]))); byid={r["active_id"]:r for r in folders if r["active_id"]}\n',
    )
    replace(
        path,
        '    out=["# Parte 2 — revisión de mod.info, dependencias y versiones","",f"Build: **{stats[\'build\']}**","","## Resumen","",f"- `Mods=`: **{stats[\'mods_line\']}** entradas",f"- Paquetes: **{stats[\'packages\']}**",f"- Carpetas: **{stats[\'folders\']}**",f"- `mod.info`: **{stats[\'mod_info\']}**",f"- IDs activos: **{stats[\'active_ids\']}**",f"- Carpetas de versión: **{stats[\'version_folders\']}**",f"- Errores: **{stats[\'errors\']}**",f"- Advertencias: **{stats[\'warnings\']}**","","## Errores",""]\n',
        '    out=["# Parte 2 — revisión de mod.info, dependencias y versiones","",f"Build: **{stats[\'build\']}**","","## Resumen","",f"- `Mods=`: **{stats[\'mods_line\']}** entradas",f"- Paquetes internos: **{stats[\'packages\']}**",f"- Carpetas internas: **{stats[\'folders\']}**",f"- `mod.info` internos: **{stats[\'mod_info\']}**",f"- IDs internos activos: **{stats[\'active_ids\']}**",f"- IDs externos declarados: **{stats[\'external_ids\']}**",f"- Carpetas de versión: **{stats[\'version_folders\']}**",f"- Errores: **{stats[\'errors\']}**",f"- Advertencias: **{stats[\'warnings\']}**","","## Errores",""]\n',
    )
    replace(
        path,
        '        if not r:out.append(f"| {n} | `{m}` | — | — | — | — | **FALTA** |");continue\n',
        '        if not r:\n            state="EXTERNO" if m in external else "FALTA"\n            out.append(f"| {n} | `{m}` | — | — | — | — | **{state}** |")\n            continue\n',
    )
    replace(
        path,
        '    out+=["","## Criterio de versión","","Se selecciona la carpeta numérica más alta que no sea posterior a Build 42.20.0. Si no existe, se usa el `mod.info` raíz o `common/mod.info`. `common/media` se considera contenido compartido.",""]\n',
        '    out+=["","## Dependencias externas","", "`NewMusic` y `eclipsemusic` se mantienen en `Mods=` y `WorkshopItems=`, pero no forman parte del contenido interno de este repositorio. Se muestran como **EXTERNO** y no se exige que tengan carpeta o `mod.info` aquí.", "", "## Criterio de versión","","Se selecciona la carpeta numérica más alta que no sea posterior a Build 42.20.0. Si no existe, se usa el `mod.info` raíz o `common/mod.info`. `common/media` se considera contenido compartido.",""]\n',
    )


if __name__ == "__main__":
    patch_general()
    patch_part2()
    print("Dependencias externas incorporadas a ambos auditores")
