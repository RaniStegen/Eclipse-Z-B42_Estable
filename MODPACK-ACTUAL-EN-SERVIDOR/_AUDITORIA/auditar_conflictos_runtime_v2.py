#!/usr/bin/env python3
"""Parte 3 v2: conflictos demostrables por ID, GUID y propiedad."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import xml.etree.ElementTree as ET
from collections import Counter, defaultdict
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any, Iterable

VERSION_RE = re.compile(r"^\d+(?:\.\d+)*$")
OPTION_RE = re.compile(r"^\s*option\s+([A-Za-z0-9_.-]+)\s*\{")
MODULE_RE = re.compile(r"^\s*module\s+([A-Za-z0-9_.-]+)\b", re.I)
DECL_RE = re.compile(r"^\s*(item|entity|vehicle|fluid)\s+([A-Za-z_][A-Za-z0-9_.-]*)\b", re.I)
PROPERTY_RE = re.compile(r"^\s*([A-Za-z_][A-Za-z0-9_.-]*)\s*=\s*(.*?)\s*,?\s*$")
REGISTER_RE = re.compile(r"\b([A-Za-z_][A-Za-z0-9_.]*)\.register\s*\(\s*[\"']([^\"']+)[\"']", re.I)
CHAT_FUNCTION_RE = re.compile(r"^\s*function\s+(ISChat[.:][A-Za-z0-9_]+)", re.M)

SENSITIVE = (
    "media/sandbox-options.txt",
    "media/registries.lua",
    "media/fileguidtable.xml",
    "media/clothing/clothing.xml",
    "media/lua/client/chat/ischat.lua",
)
CUMULATIVE = set(SENSITIVE[:-1])


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
    return parts + (0,) * max(0, 4 - len(parts))


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


def rel(path: Path, root: Path) -> str:
    try:
        return path.relative_to(root).as_posix()
    except ValueError:
        return path.as_posix()


def parse_mod_info(path: Path) -> dict[str, list[str]]:
    out: dict[str, list[str]] = defaultdict(list)
    for raw in read_text(path).splitlines():
        line = raw.strip()
        if not line or line.startswith(("#", "--", "//")) or "=" not in line:
            continue
        key, value = line.split("=", 1)
        out[key.strip()].append(value.strip())
    return dict(out)


def discover_mods(root: Path, build: str) -> dict[str, dict[str, Any]]:
    result: dict[str, dict[str, Any]] = {}
    for mods_dir in sorted(root.glob("*/Contents/mods")):
        if not mods_dir.is_dir():
            continue
        for mod_root in sorted(p for p in mods_dir.iterdir() if p.is_dir()):
            ids: set[str] = set()
            for info in sorted(mod_root.rglob("mod.info")):
                if "media" in {part.lower() for part in info.relative_to(mod_root).parts}:
                    continue
                values = parse_mod_info(info).get("id", [])
                if len(values) == 1:
                    ids.add(values[0])
            if len(ids) != 1:
                continue
            mod_id = next(iter(ids))
            versions = sorted(
                (p for p in mod_root.iterdir() if p.is_dir() and VERSION_RE.fullmatch(p.name) and compatible(p.name, build)),
                key=lambda p: version_tuple(p.name),
            )
            layers: list[tuple[str, Path]] = []
            for layer, media in (("root", mod_root / "media"), ("common", mod_root / "common" / "media")):
                if media.is_dir():
                    layers.append((layer, media))
            if versions and (versions[-1] / "media").is_dir():
                layers.append((versions[-1].name, versions[-1] / "media"))
            result[mod_id] = {"id": mod_id, "root": mod_root, "layers": layers, "version": versions[-1].name if versions else None}
    return result


def active_files(mod: dict[str, Any]) -> dict[str, dict[str, Any]]:
    files: dict[str, dict[str, Any]] = {}
    for layer, media in mod["layers"]:
        for path in media.rglob("*"):
            if not path.is_file():
                continue
            virtual = "media/" + path.relative_to(media).as_posix().lower()
            files[virtual] = {"path": path, "layer": layer, "virtual": virtual, "sha256": sha256(path), "size": path.stat().st_size}
    return files


def canonical_text(text: str) -> str:
    lines = []
    for raw in text.splitlines():
        line = re.sub(r"\s+", " ", raw.strip())
        if line and not line.startswith(("#", "--", "//")):
            lines.append(line)
    return "\n".join(lines)


def canonical_xml(elem: ET.Element) -> str:
    attrs = " ".join(f"{k}={v}" for k, v in sorted(elem.attrib.items()))
    text = (elem.text or "").strip()
    children = "".join(canonical_xml(child) for child in list(elem))
    return f"<{elem.tag} {attrs}>{text}{children}</{elem.tag}>"


def sandbox_blocks(text: str) -> list[tuple[str, str]]:
    lines = text.splitlines()
    out: list[tuple[str, str]] = []
    i = 0
    while i < len(lines):
        match = OPTION_RE.match(lines[i])
        if not match:
            i += 1
            continue
        name = match.group(1)
        block = [lines[i]]
        depth = lines[i].count("{") - lines[i].count("}")
        i += 1
        while i < len(lines) and depth > 0:
            block.append(lines[i])
            depth += lines[i].count("{") - lines[i].count("}")
            i += 1
        out.append((name, canonical_text("\n".join(block))))
    return out


def inspect_sandbox(copies: list[dict[str, Any]], findings: list[Finding]) -> dict[str, Any]:
    options: dict[str, list[dict[str, str]]] = defaultdict(list)
    duplicate_in_file = 0
    for copy in copies:
        blocks = sandbox_blocks(read_text(copy["path"]))
        counts = Counter(name for name, _ in blocks)
        for name, count in counts.items():
            if count > 1:
                duplicate_in_file += 1
                findings.append(Finding("error", "SANDBOX_OPTION_DUPLICATED_IN_FILE", f"La opción {name} está repetida {count} veces.", copy["rel"], copy["mod_id"]))
        for name, body in blocks:
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
    return {"contributors": len(copies), "options": len(options), "conflicting_options": conflicts, "identical_duplicates": identical, "duplicates_inside_file": duplicate_in_file}


def child_map(elem: ET.Element) -> dict[str, str]:
    return {child.tag.lower(): (child.text or "").strip() for child in list(elem)}


def inspect_fileguid(copies: list[dict[str, Any]], findings: list[Finding]) -> tuple[dict[str, Any], set[str]]:
    guid_to_pairs: dict[str, list[dict[str, str]]] = defaultdict(list)
    path_to_pairs: dict[str, list[dict[str, str]]] = defaultdict(list)
    exact_pairs: dict[tuple[str, str], set[str]] = defaultdict(set)
    parse_errors = 0
    for copy in copies:
        try:
            xml_root = ET.parse(copy["path"]).getroot()
        except ET.ParseError as exc:
            parse_errors += 1
            findings.append(Finding("error", "FILEGUID_XML_INVALID", str(exc), copy["rel"], copy["mod_id"]))
            continue
        for elem in xml_root.iter():
            values = child_map(elem)
            attrs = {str(k).lower(): str(v).strip() for k, v in elem.attrib.items()}
            path = values.get("path") or attrs.get("path") or attrs.get("file")
            guid = values.get("guid") or attrs.get("guid")
            if not path or not guid:
                continue
            path = path.replace("\\", "/").lower()
            guid = guid.lower()
            source = {"mod": copy["mod_id"], "file": copy["rel"], "path": path, "guid": guid}
            guid_to_pairs[guid].append(source)
            path_to_pairs[path].append(source)
            exact_pairs[(path, guid)].add(copy["mod_id"])
    guid_conflicts = 0
    path_conflicts = 0
    for guid, entries in guid_to_pairs.items():
        paths = {e["path"] for e in entries}
        if len(paths) > 1:
            guid_conflicts += 1
            findings.append(Finding("error", "FILEGUID_GUID_CONFLICT", f"El GUID {guid} apunta a rutas distintas.", details={"sources": entries}))
    for path, entries in path_to_pairs.items():
        guids = {e["guid"] for e in entries}
        if len(guids) > 1:
            path_conflicts += 1
            findings.append(Finding("error", "FILEGUID_PATH_CONFLICT", f"La ruta {path} tiene GUID distintos.", details={"sources": entries}))
    identical = sum(len(mods) > 1 for mods in exact_pairs.values())
    return ({"contributors": len(copies), "entries": len(exact_pairs), "guid_conflicts": guid_conflicts, "path_conflicts": path_conflicts, "identical_duplicates": identical, "parse_errors": parse_errors}, set(guid_to_pairs))


def inspect_clothing(copies: list[dict[str, Any]], findings: list[Finding]) -> tuple[dict[str, Any], set[str]]:
    by_name: dict[str, list[dict[str, str]]] = defaultdict(list)
    by_guid: dict[str, list[dict[str, str]]] = defaultdict(list)
    item_refs: set[str] = set()
    parse_errors = 0
    outfits = 0
    for copy in copies:
        try:
            xml_root = ET.parse(copy["path"]).getroot()
        except ET.ParseError as exc:
            parse_errors += 1
            findings.append(Finding("error", "CLOTHING_XML_INVALID", str(exc), copy["rel"], copy["mod_id"]))
            continue
        for tag in ("m_FemaleOutfits", "m_MaleOutfits"):
            for outfit in xml_root.iter(tag):
                name = (outfit.findtext("m_Name") or "").strip()
                guid = (outfit.findtext("m_Guid") or "").strip().lower()
                if not name and not guid:
                    continue
                outfits += 1
                entry = {"mod": copy["mod_id"], "path": copy["rel"], "hash": hashlib.sha256(canonical_xml(outfit).encode()).hexdigest(), "name": name, "guid": guid}
                if name:
                    by_name[name].append(entry)
                if guid:
                    by_guid[guid].append(entry)
        for node in xml_root.iter("itemGUID"):
            value = (node.text or "").strip().lower()
            if value:
                item_refs.add(value)
    name_conflicts = 0
    guid_conflicts = 0
    duplicate_inside_file = 0
    for name, defs in by_name.items():
        files = {(d["mod"], d["path"]) for d in defs}
        hashes = {d["hash"] for d in defs}
        if len(files) == 1 and len(defs) > 1 and len(hashes) > 1:
            duplicate_inside_file += 1
            findings.append(Finding("error", "CLOTHING_OUTFIT_DUPLICATED_IN_FILE", f"El outfit {name} está repetido con contenido distinto en el mismo archivo.", details={"sources": defs}))
        elif len({d["mod"] for d in defs}) > 1 and len(hashes) > 1:
            name_conflicts += 1
            findings.append(Finding("error", "CLOTHING_OUTFIT_NAME_CONFLICT", f"El outfit {name} tiene definiciones distintas.", details={"sources": defs}))
    for guid, defs in by_guid.items():
        files = {(d["mod"], d["path"]) for d in defs}
        hashes = {d["hash"] for d in defs}
        if len(files) == 1 and len(defs) > 1 and len(hashes) > 1:
            duplicate_inside_file += 1
            findings.append(Finding("error", "CLOTHING_GUID_DUPLICATED_IN_FILE", f"El GUID de outfit {guid} está repetido con contenido distinto en el mismo archivo.", details={"sources": defs}))
        elif len({d["mod"] for d in defs}) > 1 and len(hashes) > 1:
            guid_conflicts += 1
            findings.append(Finding("error", "CLOTHING_OUTFIT_GUID_CONFLICT", f"El GUID de outfit {guid} tiene definiciones distintas.", details={"sources": defs}))
    return ({"contributors": len(copies), "outfits": outfits, "unique_names": len(by_name), "unique_guids": len(by_guid), "name_conflicts": name_conflicts, "guid_conflicts": guid_conflicts, "duplicates_inside_file": duplicate_inside_file, "item_guid_references": len(item_refs), "parse_errors": parse_errors}, item_refs)


def inspect_registries(copies: list[dict[str, Any]], findings: list[Finding]) -> dict[str, Any]:
    registrations: dict[str, list[dict[str, str]]] = defaultdict(list)
    invalid_tags = 0
    for copy in copies:
        for line_number, raw in enumerate(read_text(copy["path"]).splitlines(), 1):
            line = raw.split("--", 1)[0]
            for registry_type, registry_id in REGISTER_RE.findall(line):
                normalized = registry_id.lower()
                registrations[normalized].append({"mod": copy["mod_id"], "path": copy["rel"], "line": str(line_number), "type": registry_type})
                if registry_type.lower().endswith("itemtag") and normalized.startswith("base:"):
                    invalid_tags += 1
                    findings.append(Finding("error", "INVALID_BASE_ITEMTAG", f"ItemTag.register usa {registry_id}.", copy["rel"], copy["mod_id"], {"line": line_number}))
    duplicate_ids = 0
    type_conflicts = 0
    for registry_id, defs in registrations.items():
        owners = {d["mod"] for d in defs}
        types = {d["type"].lower() for d in defs}
        if len(types) > 1:
            type_conflicts += 1
            findings.append(Finding("error", "REGISTRY_TYPE_CONFLICT", f"El ID {registry_id} se registra con tipos distintos.", details={"sources": defs}))
        elif len(owners) > 1:
            duplicate_ids += 1
            findings.append(Finding("error", "REGISTRY_ID_DUPLICATED", f"El ID {registry_id} se registra desde varios mods.", details={"sources": defs}))
    return {"contributors": len(copies), "registrations": len(registrations), "duplicate_ids": duplicate_ids, "type_conflicts": type_conflicts, "invalid_base_itemtags": invalid_tags}


def inspect_chat(copies: list[dict[str, Any]], order: dict[str, int], findings: list[Finding]) -> dict[str, Any]:
    if not copies:
        return {"copies": 0}
    effective = max(copies, key=lambda c: order.get(c["mod_id"], -1))
    text = read_text(effective["path"])
    functions = sorted(set(CHAT_FUNCTION_RE.findall(text)))
    findings.append(Finding("warning", "ISCHAT_FULL_REPLACEMENT", f"{effective['mod_id']} aporta el ISChat.lua completo.", effective["rel"], effective["mod_id"], {"layer": effective["layer"], "lines": len(text.splitlines()), "sha256": effective["sha256"], "functions": len(functions)}))
    return {"copies": len(copies), "effective_mod": effective["mod_id"], "effective_path": effective["rel"], "active_layer": effective["layer"], "lines": len(text.splitlines()), "functions": functions}


def extract_block(lines: list[str], start: int) -> list[str]:
    block: list[str] = []
    opened = 0
    balance = 0
    cursor = start
    while cursor < len(lines):
        raw = lines[cursor]
        clean = raw.split("//", 1)[0]
        block.append(raw)
        opened += clean.count("{")
        balance += clean.count("{") - clean.count("}")
        cursor += 1
        if opened > 0 and balance <= 0:
            break
    return block


def parse_properties(block: list[str]) -> dict[str, set[str]]:
    props: dict[str, set[str]] = defaultdict(set)
    depth = 0
    opened = False
    for raw in block:
        clean = raw.split("//", 1)[0].strip()
        if opened and depth == 1:
            match = PROPERTY_RE.match(clean)
            if match:
                key = match.group(1)
                value = re.sub(r"\s+", " ", match.group(2).strip().rstrip(","))
                props[key].add(value)
        opens = clean.count("{")
        closes = clean.count("}")
        if opens:
            opened = True
        depth += opens - closes
    return dict(props)


def declaration_fragments(text: str) -> Iterable[tuple[str, str, dict[str, set[str]], str]]:
    lines = text.splitlines()
    module = "?"
    depth = 0
    for index, raw in enumerate(lines):
        clean = raw.split("//", 1)[0]
        module_match = MODULE_RE.match(clean)
        if module_match and depth == 0:
            module = module_match.group(1)
        declaration = DECL_RE.match(clean) if depth == 1 else None
        if declaration:
            kind, name = declaration.group(1).lower(), declaration.group(2)
            block = extract_block(lines, index)
            body = canonical_text("\n".join(block))
            yield kind, f"{module}.{name}", parse_properties(block), hashlib.sha256(body.encode()).hexdigest()
        depth += clean.count("{") - clean.count("}")
        depth = max(depth, 0)


def scan_symbols(mods: dict[str, dict[str, Any]], order: list[str], root: Path, findings: list[Finding]) -> dict[str, Any]:
    fragments: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for mod_id in order:
        mod = mods.get(mod_id)
        if not mod:
            continue
        for virtual, file in active_files(mod).items():
            if not virtual.startswith("media/scripts/") or file["path"].suffix.lower() != ".txt":
                continue
            for kind, full_name, properties, block_hash in declaration_fragments(read_text(file["path"])):
                fragments[f"{kind}:{full_name}"].append({"mod": mod_id, "path": rel(file["path"], root), "properties": properties, "hash": block_hash})
    cross_conflicts = 0
    inside_conflicts = 0
    compatible_fragments = 0
    unparsed_warnings = 0
    for symbol, defs in fragments.items():
        if len(defs) < 2:
            continue
        property_entries: dict[str, list[dict[str, str]]] = defaultdict(list)
        for definition in defs:
            for key, values in definition["properties"].items():
                for value in values:
                    property_entries[key].append({"mod": definition["mod"], "path": definition["path"], "value": value})
        any_conflict = False
        for key, entries in property_entries.items():
            values = {e["value"] for e in entries}
            owners = {e["mod"] for e in entries}
            if len(values) <= 1:
                continue
            any_conflict = True
            if len(owners) > 1:
                cross_conflicts += 1
                findings.append(Finding("error", "SCRIPT_PROPERTY_CONFLICT", f"{symbol} asigna valores distintos a {key} en varios mods.", details={"sources": entries[:30]}))
            else:
                inside_conflicts += 1
                findings.append(Finding("error", "SCRIPT_PROPERTY_CONFLICT_IN_MOD", f"{symbol} asigna valores distintos a {key} dentro de {next(iter(owners))}.", details={"sources": entries[:30]}))
        if not any_conflict:
            if any(definition["properties"] for definition in defs):
                compatible_fragments += 1
            elif len({d["hash"] for d in defs}) > 1 and len({d["mod"] for d in defs}) > 1:
                unparsed_warnings += 1
                findings.append(Finding("warning", "SCRIPT_UNPARSED_DUPLICATE", f"{symbol} aparece en varios mods, pero no contiene propiedades simples comparables.", details={"sources": [{"mod": d["mod"], "path": d["path"]} for d in defs[:20]}))
    critical = "entity:Base.IDBFS_LiquidBarrelRack"
    if critical not in fragments:
        findings.append(Finding("error", "CRITICAL_ENTITY_MISSING", "Falta Base.IDBFS_LiquidBarrelRack."))
    return {"symbols": len(fragments), "cross_mod_property_conflicts": cross_conflicts, "inside_mod_property_conflicts": inside_conflicts, "compatible_fragmented_symbols": compatible_fragments, "unparsed_duplicate_warnings": unparsed_warnings, "critical_entity_present": critical in fragments, "critical_entity_sources": [{"mod": d["mod"], "path": d["path"]} for d in fragments.get(critical, [])]}


def audit(root: Path, config: dict[str, Any]) -> tuple[list[Finding], dict[str, Any]]:
    findings: list[Finding] = []
    build = str(config["build"])
    mods_order = [str(x) for x in config.get("mods", [])]
    external = {str(x) for x in config.get("external_mods", [])}
    order_index = {mod_id: index for index, mod_id in enumerate(mods_order)}
    mods = discover_mods(root, build)
    files_by_virtual: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for mod_id in mods_order:
        if mod_id in external or mod_id not in mods:
            continue
        for virtual, file in active_files(mods[mod_id]).items():
            files_by_virtual[virtual].append({**file, "mod_id": mod_id, "rel": rel(file["path"], root), "order": order_index[mod_id]})
    sensitive: dict[str, Any] = {}
    known_guids: set[str] = set()
    clothing_refs: set[str] = set()
    for virtual in SENSITIVE:
        copies = files_by_virtual.get(virtual, [])
        entry = {"mode": "cumulative" if virtual in CUMULATIVE else "replacement", "copies": len(copies), "contributors": [c["mod_id"] for c in sorted(copies, key=lambda c: c["order"])], "paths": [c["rel"] for c in sorted(copies, key=lambda c: c["order"])], "unique_hashes": len({c["sha256"] for c in copies})}
        if virtual == "media/sandbox-options.txt":
            entry["semantic"] = inspect_sandbox(copies, findings)
        elif virtual == "media/registries.lua":
            entry["semantic"] = inspect_registries(copies, findings)
        elif virtual == "media/fileguidtable.xml":
            entry["semantic"], known_guids = inspect_fileguid(copies, findings)
        elif virtual == "media/clothing/clothing.xml":
            entry["semantic"], clothing_refs = inspect_clothing(copies, findings)
        else:
            entry["semantic"] = inspect_chat(copies, order_index, findings)
        sensitive[virtual] = entry
    collisions = {path: copies for path, copies in files_by_virtual.items() if len({c["mod_id"] for c in copies}) > 1}
    translations = sum(path.startswith("media/lua/shared/translate/") for path in collisions)
    keep = sum(path.endswith("/.keep") for path in collisions)
    symbols = scan_symbols(mods, mods_order, root, findings)
    stats = {"build": build, "internal_mods_discovered": len(mods), "external_mods": sorted(external), "active_virtual_files": len(files_by_virtual), "shared_virtual_paths": len(collisions), "translation_shared_paths": translations, "keep_shared_paths": keep, "other_shared_paths": len(collisions) - translations - keep, "sensitive": sensitive, "fileguid_known_guids": len(known_guids), "clothing_item_guid_references": len(clothing_refs), "clothing_refs_not_in_mod_fileguid": len(clothing_refs - known_guids), "symbols": symbols, "errors": sum(f.severity == "error" for f in findings), "warnings": sum(f.severity == "warning" for f in findings)}
    return findings, stats


def markdown(findings: list[Finding], stats: dict[str, Any]) -> str:
    out = ["# Parte 3 — conflictos globales y runtime", "", f"Build: **{stats['build']}**", "", "## Resumen", "", f"- Mods internos: **{stats['internal_mods_discovered']}**", f"- Rutas activas: **{stats['active_virtual_files']}**", f"- Rutas compartidas: **{stats['shared_virtual_paths']}**", f"- Traducciones compartidas: **{stats['translation_shared_paths']}**", f"- Otras rutas compartidas: **{stats['other_shared_paths']}**", f"- Errores: **{stats['errors']}**", f"- Advertencias: **{stats['warnings']}**", "", "Una ruta compartida no es un error por sí sola. Solo se informa cuando existe un conflicto de ID, GUID, opción o propiedad.", "", "## Archivos globales", "", "| Ruta | Modo | Copias | Resultado |", "|---|---|---:|---|"]
    for virtual, data in stats["sensitive"].items():
        semantic = data.get("semantic", {})
        summary = ", ".join(f"{k}={v}" for k, v in semantic.items() if isinstance(v, (str, int, bool))) or "—"
        out.append(f"| `{virtual}` | {data['mode']} | {data['copies']} | {summary} |")
    out.extend(["", "## Scripts y entidades", "", f"- Símbolos: **{stats['symbols']['symbols']}**", f"- Conflictos de propiedades entre mods: **{stats['symbols']['cross_mod_property_conflicts']}**", f"- Conflictos de propiedades dentro de un mod: **{stats['symbols']['inside_mod_property_conflicts']}**", f"- Parches fragmentarios compatibles: **{stats['symbols']['compatible_fragmented_symbols']}**", f"- Duplicados no analizables: **{stats['symbols']['unparsed_duplicate_warnings']}**", f"- `Base.IDBFS_LiquidBarrelRack`: **{'presente' if stats['symbols']['critical_entity_present'] else 'ausente'}**", "", "## Hallazgos", ""])
    if not findings:
        out.append("No se encontraron conflictos demostrables.")
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
    out.extend(["## Nota", "", "Las referencias de ropa ausentes de los fileGuidTable de mods pueden pertenecer al juego base y no se consideran error sin el fileGuidTable vanilla de Build 42.20.", ""])
    return "\n".join(out)


def main() -> int:
    a = parse_args()
    config = json.loads(a.config.read_text(encoding="utf-8-sig"))
    findings, stats = audit(a.root.resolve(), config)
    a.output.parent.mkdir(parents=True, exist_ok=True)
    a.output.with_suffix(".json").write_text(json.dumps({"stats": stats, "findings": [asdict(f) for f in findings]}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    a.output.with_suffix(".md").write_text(markdown(findings, stats), encoding="utf-8")
    print(f"Parte 3 v2: {stats['errors']} errores, {stats['warnings']} advertencias")
    return 1 if stats["errors"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
