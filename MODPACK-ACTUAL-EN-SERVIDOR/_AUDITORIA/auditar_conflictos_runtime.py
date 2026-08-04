#!/usr/bin/env python3
"""Parte 3: conflictos globales, símbolos persistentes y riesgos de runtime.

Analiza únicamente el contenido interno de MODPACK-ACTUAL-EN-SERVIDOR. Las
 dependencias externas declaradas en la configuración se conservan en el orden
 de carga, pero no se exige que sus archivos estén presentes en el repositorio.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
import xml.etree.ElementTree as ET
from collections import defaultdict
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any, Iterable

VERSION_RE = re.compile(r"^\d+(?:\.\d+)*$")
OPTION_RE = re.compile(r"^\s*option\s+([A-Za-z0-9_.-]+)\s*\{")
MODULE_RE = re.compile(r"\bmodule\s+([A-Za-z0-9_.-]+)")
SCRIPT_DECL_RE = re.compile(r"^\s*(item|entity|vehicle|fluid)\s+([A-Za-z0-9_.-]+)\b", re.I | re.M)
LUA_TABLE_KEY_RE = re.compile(r"(?:\[\s*[\"']([^\"']+)[\"']\s*\]|^\s*([A-Za-z_][A-Za-z0-9_.-]*))\s*=", re.M)
LUA_REGISTER_RE = re.compile(r"\b(?:register|add|insert)[A-Za-z0-9_]*\s*\(\s*[\"']([^\"']+)[\"']", re.I)
CHAT_FUNCTION_RE = re.compile(r"^\s*function\s+(ISChat[.:][A-Za-z0-9_]+)", re.M)

SENSITIVE = {
    "media/sandbox-options.txt",
    "media/registries.lua",
    "media/fileguidtable.xml",
    "media/clothing/clothing.xml",
    "media/lua/client/chat/ischat.lua",
}

@dataclass
class Finding:
    severity: str
    code: str
    message: str
    path: str | None = None
    mod_id: str | None = None
    details: dict[str, Any] | None = None


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser()
    p.add_argument("root", nargs="?", type=Path, default=Path(__file__).resolve().parents[1])
    p.add_argument("--config", type=Path, default=Path(__file__).with_name("configuracion_servidor_actual.json"))
    p.add_argument("--output", type=Path, default=Path(__file__).with_name("resultado_parte3"))
    return p.parse_args()


def version_tuple(value: str) -> tuple[int, ...]:
    parts = tuple(int(x) for x in value.split("."))
    return parts + (0,) * (4 - len(parts))


def compatible(version: str, build: str) -> bool:
    return version_tuple(version) <= version_tuple(build)


def sha256(path: Path) -> str:
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


def parse_mod_info(path: Path) -> dict[str, list[str]]:
    out: dict[str, list[str]] = defaultdict(list)
    for raw in read_text(path).splitlines():
        line = raw.strip()
        if not line or line.startswith(("#", "--", "//")) or "=" not in line:
            continue
        k, v = line.split("=", 1)
        out[k.strip()].append(v.strip())
    return dict(out)


def rel(path: Path, root: Path) -> str:
    try:
        return path.relative_to(root).as_posix()
    except ValueError:
        return path.as_posix()


def discover_mods(root: Path, build: str) -> dict[str, dict[str, Any]]:
    found: dict[str, dict[str, Any]] = {}
    for mods_dir in sorted(root.glob("*/Contents/mods")):
        if not mods_dir.is_dir():
            continue
        for mod_root in sorted(p for p in mods_dir.iterdir() if p.is_dir()):
            infos = []
            for info in sorted(mod_root.rglob("mod.info")):
                if "media" in {part.lower() for part in info.relative_to(mod_root).parts}:
                    continue
                data = parse_mod_info(info)
                ids = data.get("id", [])
                if len(ids) == 1:
                    infos.append((info, ids[0], data))
            if not infos:
                continue
            ids = {entry[1] for entry in infos}
            if len(ids) != 1:
                continue
            mod_id = next(iter(ids))
            versions = sorted(
                [p for p in mod_root.iterdir() if p.is_dir() and VERSION_RE.fullmatch(p.name) and compatible(p.name, build)],
                key=lambda p: version_tuple(p.name),
            )
            layers: list[tuple[str, Path]] = []
            if (mod_root / "media").is_dir():
                layers.append(("root", mod_root / "media"))
            if (mod_root / "common" / "media").is_dir():
                layers.append(("common", mod_root / "common" / "media"))
            if versions and (versions[-1] / "media").is_dir():
                layers.append((versions[-1].name, versions[-1] / "media"))
            found[mod_id] = {
                "id": mod_id,
                "root": mod_root,
                "layers": layers,
                "version": versions[-1].name if versions else None,
            }
    return found


def active_files(mod: dict[str, Any]) -> dict[str, dict[str, Any]]:
    """Devuelve una vista efectiva por ruta virtual dentro de un mod.

    root < common < versión activa. La última capa sustituye la ruta previa.
    """
    files: dict[str, dict[str, Any]] = {}
    for layer_name, media in mod["layers"]:
        for path in media.rglob("*"):
            if not path.is_file():
                continue
            virtual = "media/" + path.relative_to(media).as_posix().lower()
            files[virtual] = {
                "path": path,
                "layer": layer_name,
                "virtual": virtual,
                "sha256": sha256(path),
                "size": path.stat().st_size,
            }
    return files


def canonical_text(text: str) -> str:
    lines = []
    for raw in text.splitlines():
        line = re.sub(r"\s+", " ", raw.strip())
        if line and not line.startswith(("#", "--", "//")):
            lines.append(line)
    return "\n".join(lines)


def sandbox_blocks(text: str) -> dict[str, str]:
    lines = text.splitlines()
    out: dict[str, str] = {}
    i = 0
    while i < len(lines):
        m = OPTION_RE.match(lines[i])
        if not m:
            i += 1
            continue
        name = m.group(1)
        block = [lines[i]]
        depth = lines[i].count("{") - lines[i].count("}")
        i += 1
        while i < len(lines) and depth > 0:
            block.append(lines[i])
            depth += lines[i].count("{") - lines[i].count("}")
            i += 1
        out[name] = canonical_text("\n".join(block))
    return out


def canonical_xml(elem: ET.Element) -> str:
    attrs = " ".join(f"{k}={v}" for k, v in sorted(elem.attrib.items()))
    text = (elem.text or "").strip()
    children = "".join(canonical_xml(child) for child in list(elem))
    return f"<{elem.tag} {attrs}>{text}{children}</{elem.tag}>"


def first_identifier(elem: ET.Element) -> str | None:
    for key in ("id", "name", "guid", "GUID", "m_Name", "item", "path", "file"):
        if elem.attrib.get(key):
            return elem.attrib[key]
    for child_name in ("m_Name", "name", "id", "m_GUID", "guid"):
        child = elem.find(child_name)
        if child is not None and (child.text or "").strip():
            return (child.text or "").strip()
    return None


def inspect_fileguid(copies: list[dict[str, Any]], findings: list[Finding]) -> dict[str, Any]:
    guid_to_path: dict[str, set[str]] = defaultdict(set)
    path_to_guid: dict[str, set[str]] = defaultdict(set)
    parse_errors = []
    for copy in copies:
        try:
            root = ET.parse(copy["path"]).getroot()
        except ET.ParseError as exc:
            parse_errors.append({"path": copy["rel"], "error": str(exc)})
            findings.append(Finding("error", "FILEGUID_XML_INVALID", str(exc), copy["rel"], copy["mod_id"]))
            continue
        for elem in root.iter():
            attrs = {str(k).lower(): str(v) for k, v in elem.attrib.items()}
            guid = attrs.get("guid") or attrs.get("id")
            path = attrs.get("path") or attrs.get("file") or attrs.get("name")
            if guid and path:
                guid_to_path[guid].add(path.lower())
                path_to_guid[path.lower()].add(guid)
    for guid, paths in guid_to_path.items():
        if len(paths) > 1:
            findings.append(Finding("error", "FILEGUID_GUID_CONFLICT", f"El GUID {guid} apunta a rutas distintas.", details={"paths": sorted(paths)}))
    for path, guids in path_to_guid.items():
        if len(guids) > 1:
            findings.append(Finding("error", "FILEGUID_PATH_CONFLICT", f"La ruta {path} tiene GUID distintos.", details={"guids": sorted(guids)}))
    return {
        "guid_entries": len(guid_to_path),
        "path_entries": len(path_to_guid),
        "parse_errors": parse_errors,
        "guid_conflicts": sum(len(v) > 1 for v in guid_to_path.values()),
        "path_conflicts": sum(len(v) > 1 for v in path_to_guid.values()),
    }


def inspect_clothing(copies: list[dict[str, Any]], findings: list[Finding]) -> dict[str, Any]:
    definitions: dict[tuple[str, str], list[dict[str, str]]] = defaultdict(list)
    parse_errors = []
    for copy in copies:
        try:
            root = ET.parse(copy["path"]).getroot()
        except ET.ParseError as exc:
            parse_errors.append({"path": copy["rel"], "error": str(exc)})
            findings.append(Finding("error", "CLOTHING_XML_INVALID", str(exc), copy["rel"], copy["mod_id"]))
            continue
        for elem in root.iter():
            ident = first_identifier(elem)
            if not ident:
                continue
            key = (elem.tag.lower(), ident)
            definitions[key].append({"mod": copy["mod_id"], "path": copy["rel"], "canonical": canonical_xml(elem)})
    conflicts = 0
    identical = 0
    for (tag, ident), defs in definitions.items():
        owners = {d["mod"] for d in defs}
        variants = {d["canonical"] for d in defs}
        if len(owners) > 1 and len(variants) > 1:
            conflicts += 1
            findings.append(Finding("error", "CLOTHING_DEFINITION_CONFLICT", f"{tag}:{ident} tiene definiciones distintas en varios mods.", details={"sources": [{"mod": d["mod"], "path": d["path"]} for d in defs]}))
        elif len(owners) > 1:
            identical += 1
    return {
        "identified_elements": len(definitions),
        "conflicting_definitions": conflicts,
        "identical_duplicates": identical,
        "parse_errors": parse_errors,
    }


def inspect_registries(copies: list[dict[str, Any]], findings: list[Finding]) -> dict[str, Any]:
    keys: dict[str, list[dict[str, str]]] = defaultdict(list)
    for copy in copies:
        text = read_text(copy["path"])
        for m in LUA_TABLE_KEY_RE.finditer(text):
            key = m.group(1) or m.group(2)
            if key:
                line = text[m.start(): text.find("\n", m.start()) if text.find("\n", m.start()) != -1 else len(text)].strip()
                keys[key].append({"mod": copy["mod_id"], "path": copy["rel"], "line": canonical_text(line)})
        for m in LUA_REGISTER_RE.finditer(text):
            key = m.group(1)
            line = text[m.start(): text.find("\n", m.start()) if text.find("\n", m.start()) != -1 else len(text)].strip()
            keys[f"call:{key}"].append({"mod": copy["mod_id"], "path": copy["rel"], "line": canonical_text(line)})
    conflicts = 0
    identical = 0
    for key, defs in keys.items():
        owners = {d["mod"] for d in defs}
        variants = {d["line"] for d in defs}
        if len(owners) > 1 and len(variants) > 1:
            conflicts += 1
            findings.append(Finding("warning", "REGISTRY_KEY_CONFLICT", f"La clave de registro {key} aparece con líneas distintas.", details={"sources": defs[:20]}))
        elif len(owners) > 1:
            identical += 1
    return {"keys": len(keys), "conflicting_keys": conflicts, "identical_duplicates": identical}


def inspect_sandbox(copies: list[dict[str, Any]], findings: list[Finding]) -> dict[str, Any]:
    options: dict[str, list[dict[str, str]]] = defaultdict(list)
    for copy in copies:
        for name, body in sandbox_blocks(read_text(copy["path"])).items():
            options[name].append({"mod": copy["mod_id"], "path": copy["rel"], "body": body})
    conflicts = 0
    identical = 0
    for name, defs in options.items():
        owners = {d["mod"] for d in defs}
        variants = {d["body"] for d in defs}
        if len(owners) > 1 and len(variants) > 1:
            conflicts += 1
            findings.append(Finding("error", "SANDBOX_OPTION_CONFLICT", f"La opción {name} tiene definiciones distintas.", details={"sources": [{"mod": d["mod"], "path": d["path"]} for d in defs]}))
        elif len(owners) > 1:
            identical += 1
    return {"options": len(options), "conflicting_options": conflicts, "identical_duplicates": identical}


def inspect_chat(copies: list[dict[str, Any]], order: dict[str, int], findings: list[Finding]) -> dict[str, Any]:
    if not copies:
        return {"copies": 0}
    effective = max(copies, key=lambda c: order.get(c["mod_id"], -1))
    text = read_text(effective["path"])
    funcs = sorted(set(CHAT_FUNCTION_RE.findall(text)))
    findings.append(Finding(
        "warning",
        "ISCHAT_FULL_REPLACEMENT",
        f"{effective['mod_id']} aporta el ISChat.lua efectivo completo; requiere prueba tras cada actualización del juego.",
        effective["rel"],
        effective["mod_id"],
        {"lines": len(text.splitlines()), "sha256": effective["sha256"], "functions": len(funcs)},
    ))
    return {
        "copies": len(copies),
        "effective_mod": effective["mod_id"],
        "effective_path": effective["rel"],
        "lines": len(text.splitlines()),
        "functions": funcs,
        "hashes": sorted({c["sha256"] for c in copies}),
    }


def scan_symbols(mods: dict[str, dict[str, Any]], order: list[str], root: Path, findings: list[Finding]) -> dict[str, Any]:
    symbols: dict[str, list[dict[str, str]]] = defaultdict(list)
    for mod_id in order:
        mod = mods.get(mod_id)
        if not mod:
            continue
        for virtual, file in active_files(mod).items():
            if not virtual.startswith("media/scripts/") or file["path"].suffix.lower() != ".txt":
                continue
            text = read_text(file["path"])
            module_match = MODULE_RE.search(text)
            module = module_match.group(1) if module_match else "?"
            for kind, name in SCRIPT_DECL_RE.findall(text):
                full = f"{module}.{name}"
                symbols[f"{kind.lower()}:{full}"].append({"mod": mod_id, "path": rel(file["path"], root)})
    duplicate_conflicts = 0
    for symbol, defs in symbols.items():
        owners = {d["mod"] for d in defs}
        if len(owners) > 1:
            duplicate_conflicts += 1
            severity = "error" if symbol.startswith(("item:", "entity:", "vehicle:", "fluid:")) else "warning"
            findings.append(Finding(severity, "SCRIPT_SYMBOL_DUPLICATED", f"{symbol} está declarado en varios mods.", details={"sources": defs}))
    critical = "entity:Base.IDBFS_LiquidBarrelRack"
    if critical not in symbols:
        findings.append(Finding("error", "CRITICAL_ENTITY_MISSING", "Falta Base.IDBFS_LiquidBarrelRack en los scripts activos."))
    return {
        "symbols": len(symbols),
        "duplicate_symbols": duplicate_conflicts,
        "critical_entity_present": critical in symbols,
        "critical_entity_sources": symbols.get(critical, []),
    }


def audit(root: Path, config: dict[str, Any]) -> tuple[list[Finding], dict[str, Any]]:
    findings: list[Finding] = []
    build = str(config["build"])
    order_list = [str(x) for x in config.get("mods", [])]
    external = {str(x) for x in config.get("external_mods", [])}
    order = {mod_id: i for i, mod_id in enumerate(order_list)}
    mods = discover_mods(root, build)

    copies_by_virtual: dict[str, list[dict[str, Any]]] = defaultdict(list)
    all_collisions: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for mod_id in order_list:
        if mod_id in external or mod_id not in mods:
            continue
        for virtual, file in active_files(mods[mod_id]).items():
            copy = {
                **file,
                "mod_id": mod_id,
                "rel": rel(file["path"], root),
                "order": order[mod_id],
            }
            all_collisions[virtual].append(copy)
            if virtual in SENSITIVE:
                copies_by_virtual[virtual].append(copy)

    sensitive_report: dict[str, Any] = {}
    for virtual in sorted(SENSITIVE):
        copies = copies_by_virtual.get(virtual, [])
        effective = max(copies, key=lambda c: c["order"]) if copies else None
        report = {
            "copies": len(copies),
            "owners": [c["mod_id"] for c in sorted(copies, key=lambda c: c["order"])],
            "paths": [c["rel"] for c in sorted(copies, key=lambda c: c["order"])],
            "hashes": sorted({c["sha256"] for c in copies}),
            "identical": len({c["sha256"] for c in copies}) <= 1,
            "effective_mod": effective["mod_id"] if effective else None,
            "effective_path": effective["rel"] if effective else None,
        }
        if virtual == "media/sandbox-options.txt":
            report["semantic"] = inspect_sandbox(copies, findings)
        elif virtual == "media/fileguidtable.xml":
            report["semantic"] = inspect_fileguid(copies, findings)
        elif virtual == "media/clothing/clothing.xml":
            report["semantic"] = inspect_clothing(copies, findings)
        elif virtual == "media/registries.lua":
            report["semantic"] = inspect_registries(copies, findings)
        elif virtual == "media/lua/client/chat/ischat.lua":
            report["semantic"] = inspect_chat(copies, order, findings)
        sensitive_report[virtual] = report

    exact_collisions = {
        virtual: copies
        for virtual, copies in all_collisions.items()
        if len({c["mod_id"] for c in copies}) > 1
    }
    non_identical_collisions = 0
    for virtual, copies in exact_collisions.items():
        hashes = {c["sha256"] for c in copies}
        if len(hashes) > 1:
            non_identical_collisions += 1
            if virtual in SENSITIVE:
                continue
            findings.append(Finding(
                "warning",
                "VIRTUAL_PATH_COLLISION",
                f"La ruta {virtual} tiene versiones distintas y prevalece el último mod de Mods=.",
                details={
                    "owners": [c["mod_id"] for c in sorted(copies, key=lambda c: c["order"])],
                    "effective": max(copies, key=lambda c: c["order"])["mod_id"],
                },
            ))

    symbols = scan_symbols(mods, order_list, root, findings)
    stats = {
        "build": build,
        "internal_mods_discovered": len(mods),
        "external_mods": sorted(external),
        "active_virtual_files": len(all_collisions),
        "colliding_virtual_paths": len(exact_collisions),
        "non_identical_virtual_collisions": non_identical_collisions,
        "sensitive": sensitive_report,
        "symbols": symbols,
        "errors": sum(f.severity == "error" for f in findings),
        "warnings": sum(f.severity == "warning" for f in findings),
    }
    return findings, stats


def markdown(findings: list[Finding], stats: dict[str, Any]) -> str:
    out = [
        "# Parte 3 — conflictos globales y preparación de runtime",
        "",
        f"Build: **{stats['build']}**",
        "",
        "## Resumen",
        "",
        f"- Mods internos detectados: **{stats['internal_mods_discovered']}**",
        f"- Rutas virtuales activas: **{stats['active_virtual_files']}**",
        f"- Rutas presentes en varios mods: **{stats['colliding_virtual_paths']}**",
        f"- Colisiones con contenido distinto: **{stats['non_identical_virtual_collisions']}**",
        f"- Errores: **{stats['errors']}**",
        f"- Advertencias: **{stats['warnings']}**",
        "",
        "## Archivos globales sensibles",
        "",
        "| Ruta | Copias | Orden de propietarios | Efectivo | Idénticas | Resultado semántico |",
        "|---|---:|---|---|---|---|",
    ]
    for virtual, data in stats["sensitive"].items():
        semantic = data.get("semantic", {})
        summary = ", ".join(f"{k}={v}" for k, v in semantic.items() if isinstance(v, (str, int, bool))) or "—"
        out.append(f"| `{virtual}` | {data['copies']} | {' → '.join(data['owners']) or '—'} | `{data['effective_mod'] or '—'}` | {'sí' if data['identical'] else 'no'} | {summary} |")
    out.extend(["", "## Símbolos persistentes", ""])
    out.append(f"- Símbolos analizados: **{stats['symbols']['symbols']}**")
    out.append(f"- Símbolos duplicados: **{stats['symbols']['duplicate_symbols']}**")
    out.append(f"- `Base.IDBFS_LiquidBarrelRack`: **{'presente' if stats['symbols']['critical_entity_present'] else 'ausente'}**")
    out.extend(["", "## Hallazgos", ""])
    if not findings:
        out.append("No se encontraron conflictos ni riesgos adicionales.")
    for finding in sorted(findings, key=lambda f: (0 if f.severity == "error" else 1, f.code, f.path or "")):
        icon = "❌" if finding.severity == "error" else "⚠️"
        out.extend([f"### {icon} `{finding.code}`", "", finding.message])
        if finding.mod_id:
            out.extend(["", f"Mod: `{finding.mod_id}`"])
        if finding.path:
            out.extend(["", f"Ruta: `{finding.path}`"])
        if finding.details:
            out.extend(["", "```json", json.dumps(finding.details, ensure_ascii=False, indent=2), "```"])
        out.append("")
    out.extend([
        "## Límites de esta pasada",
        "",
        "La auditoría estática no sustituye una conexión real a Project Zomboid. La validación de Workshop, servidor, cliente y partida existente se realiza con los manifiestos y el validador de logs incluidos en esta misma carpeta.",
        "",
    ])
    return "\n".join(out)


def main() -> int:
    args = parse_args()
    root = args.root.resolve()
    config = json.loads(args.config.read_text(encoding="utf-8-sig"))
    findings, stats = audit(root, config)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.with_suffix(".json").write_text(
        json.dumps({"stats": stats, "findings": [asdict(f) for f in findings]}, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    args.output.with_suffix(".md").write_text(markdown(findings, stats), encoding="utf-8")
    print(f"Parte 3: {stats['errors']} errores, {stats['warnings']} advertencias")
    return 1 if stats["errors"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
