#!/usr/bin/env python3
"""Parte 3: conflictos globales, símbolos persistentes y riesgos de runtime.

Los archivos especiales de Project Zomboid (`sandbox-options.txt`,
`registries.lua`, `fileGuidTable.xml` y `clothing.xml`) se analizan como
contribuciones acumulativas de cada mod, no como sustituciones por orden.
"""
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
    found: dict[str, dict[str, Any]] = {}
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
            for layer_name, media in (
                ("root", mod_root / "media"),
                ("common", mod_root / "common" / "media"),
            ):
                if media.is_dir():
                    layers.append((layer_name, media))
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
    """Vista efectiva dentro de un solo mod: root < common < versión activa."""
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


def canonical_xml(elem: ET.Element) -> str:
    attrs = " ".join(f"{k}={v}" for k, v in sorted(elem.attrib.items()))
    text = (elem.text or "").strip()
    children = "".join(canonical_xml(child) for child in list(elem))
    return f"<{elem.tag} {attrs}>{text}{children}</{elem.tag}>"


def sandbox_blocks(text: str) -> list[tuple[str, str]]:
    lines = text.splitlines()
    out: list[tuple[str, str]] = []
    index = 0
    while index < len(lines):
        match = OPTION_RE.match(lines[index])
        if not match:
            index += 1
            continue
        name = match.group(1)
        block = [lines[index]]
        depth = lines[index].count("{") - lines[index].count("}")
        index += 1
        while index < len(lines) and depth > 0:
            block.append(lines[index])
            depth += lines[index].count("{") - lines[index].count("}")
            index += 1
        out.append((name, canonical_text("\n".join(block))))
    return out


def inspect_sandbox(copies: list[dict[str, Any]], findings: list[Finding]) -> dict[str, Any]:
    options: dict[str, list[dict[str, str]]] = defaultdict(list)
    within_file_duplicates = 0
    for copy in copies:
        blocks = sandbox_blocks(read_text(copy["path"]))
        counts = Counter(name for name, _ in blocks)
        for name, count in counts.items():
            if count > 1:
                within_file_duplicates += 1
                findings.append(Finding(
                    "error", "SANDBOX_OPTION_DUPLICATED_IN_FILE",
                    f"La opción {name} está repetida {count} veces en el mismo archivo.",
                    copy["rel"], copy["mod_id"],
                ))
        for name, body in blocks:
            options[name].append({"mod": copy["mod_id"], "path": copy["rel"], "body": body})
    conflicts = 0
    identical = 0
    for name, definitions in options.items():
        owners = {entry["mod"] for entry in definitions}
        variants = {entry["body"] for entry in definitions}
        if len(owners) > 1 and len(variants) > 1:
            conflicts += 1
            findings.append(Finding(
                "error", "SANDBOX_OPTION_CONFLICT",
                f"La opción {name} tiene definiciones distintas en varios mods.",
                details={"sources": [{"mod": d["mod"], "path": d["path"]} for d in definitions]},
            ))
        elif len(owners) > 1:
            identical += 1
    return {
        "contributors": len(copies),
        "options": len(options),
        "conflicting_options": conflicts,
        "identical_duplicates": identical,
        "duplicates_inside_file": within_file_duplicates,
    }


def child_text_map(elem: ET.Element) -> dict[str, str]:
    return {child.tag.lower(): (child.text or "").strip() for child in list(elem)}


def inspect_fileguid(copies: list[dict[str, Any]], findings: list[Finding]) -> tuple[dict[str, Any], set[str]]:
    guid_to_paths: dict[str, set[str]] = defaultdict(set)
    path_to_guids: dict[str, set[str]] = defaultdict(set)
    pair_sources: dict[tuple[str, str], set[str]] = defaultdict(set)
    parse_errors = 0
    for copy in copies:
        try:
            xml_root = ET.parse(copy["path"]).getroot()
        except ET.ParseError as exc:
            parse_errors += 1
            findings.append(Finding("error", "FILEGUID_XML_INVALID", str(exc), copy["rel"], copy["mod_id"]))
            continue
        for elem in xml_root.iter():
            values = child_text_map(elem)
            attrs = {str(k).lower(): str(v).strip() for k, v in elem.attrib.items()}
            path = values.get("path") or attrs.get("path") or attrs.get("file")
            guid = values.get("guid") or attrs.get("guid")
            if not path or not guid:
                continue
            normalized_path = path.replace("\\", "/").lower()
            normalized_guid = guid.lower()
            guid_to_paths[normalized_guid].add(normalized_path)
            path_to_guids[normalized_path].add(normalized_guid)
            pair_sources[(normalized_path, normalized_guid)].add(copy["mod_id"])
    guid_conflicts = 0
    path_conflicts = 0
    identical_duplicates = 0
    for guid, paths in guid_to_paths.items():
        if len(paths) > 1:
            guid_conflicts += 1
            findings.append(Finding("error", "FILEGUID_GUID_CONFLICT", f"El GUID {guid} apunta a rutas distintas.", details={"paths": sorted(paths)}))
    for path, guids in path_to_guids.items():
        if len(guids) > 1:
            path_conflicts += 1
            findings.append(Finding("error", "FILEGUID_PATH_CONFLICT", f"La ruta {path} tiene GUID distintos.", details={"guids": sorted(guids)}))
    for sources in pair_sources.values():
        if len(sources) > 1:
            identical_duplicates += 1
    return ({
        "contributors": len(copies),
        "entries": len(pair_sources),
        "guid_conflicts": guid_conflicts,
        "path_conflicts": path_conflicts,
        "identical_duplicates": identical_duplicates,
        "parse_errors": parse_errors,
    }, set(guid_to_paths))


def inspect_clothing(copies: list[dict[str, Any]], findings: list[Finding]) -> tuple[dict[str, Any], set[str]]:
    by_name: dict[str, list[dict[str, str]]] = defaultdict(list)
    by_guid: dict[str, list[dict[str, str]]] = defaultdict(list)
    referenced_item_guids: set[str] = set()
    parse_errors = 0
    outfit_count = 0
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
                outfit_count += 1
                entry = {
                    "mod": copy["mod_id"],
                    "path": copy["rel"],
                    "hash": hashlib.sha256(canonical_xml(outfit).encode("utf-8")).hexdigest(),
                    "name": name,
                    "guid": guid,
                }
                if name:
                    by_name[name].append(entry)
                if guid:
                    by_guid[guid].append(entry)
        for item_guid in xml_root.iter("itemGUID"):
            value = (item_guid.text or "").strip().lower()
            if value:
                referenced_item_guids.add(value)
    name_conflicts = 0
    guid_conflicts = 0
    identical_duplicates = 0
    for name, definitions in by_name.items():
        owners = {d["mod"] for d in definitions}
        hashes = {d["hash"] for d in definitions}
        if len(owners) > 1 and len(hashes) > 1:
            name_conflicts += 1
            findings.append(Finding("error", "CLOTHING_OUTFIT_NAME_CONFLICT", f"El outfit {name} tiene definiciones distintas.", details={"sources": definitions}))
        elif len(owners) > 1:
            identical_duplicates += 1
    for guid, definitions in by_guid.items():
        owners = {d["mod"] for d in definitions}
        hashes = {d["hash"] for d in definitions}
        if len(owners) > 1 and len(hashes) > 1:
            guid_conflicts += 1
            findings.append(Finding("error", "CLOTHING_OUTFIT_GUID_CONFLICT", f"El GUID de outfit {guid} tiene definiciones distintas.", details={"sources": definitions}))
    return ({
        "contributors": len(copies),
        "outfits": outfit_count,
        "unique_names": len(by_name),
        "unique_guids": len(by_guid),
        "name_conflicts": name_conflicts,
        "guid_conflicts": guid_conflicts,
        "identical_duplicates": identical_duplicates,
        "item_guid_references": len(referenced_item_guids),
        "parse_errors": parse_errors,
    }, referenced_item_guids)


def inspect_registries(copies: list[dict[str, Any]], findings: list[Finding]) -> dict[str, Any]:
    registrations: dict[str, list[dict[str, str]]] = defaultdict(list)
    invalid_base_tags = 0
    for copy in copies:
        for line_number, raw in enumerate(read_text(copy["path"]).splitlines(), 1):
            line = raw.split("--", 1)[0]
            for registry_type, registry_id in REGISTER_RE.findall(line):
                normalized_id = registry_id.lower()
                registrations[normalized_id].append({
                    "mod": copy["mod_id"],
                    "path": copy["rel"],
                    "line": str(line_number),
                    "type": registry_type,
                })
                if registry_type.lower().endswith("itemtag") and normalized_id.startswith("base:"):
                    invalid_base_tags += 1
                    findings.append(Finding(
                        "error", "INVALID_BASE_ITEMTAG",
                        f"ItemTag.register usa el espacio de nombres inválido {registry_id}.",
                        copy["rel"], copy["mod_id"], {"line": line_number},
                    ))
    duplicate_ids = 0
    type_conflicts = 0
    for registry_id, definitions in registrations.items():
        owners = {d["mod"] for d in definitions}
        types = {d["type"].lower() for d in definitions}
        if len(types) > 1:
            type_conflicts += 1
            findings.append(Finding("error", "REGISTRY_TYPE_CONFLICT", f"El ID {registry_id} se registra con tipos distintos.", details={"sources": definitions}))
        elif len(owners) > 1:
            duplicate_ids += 1
            findings.append(Finding("error", "REGISTRY_ID_DUPLICATED", f"El ID {registry_id} se registra desde varios mods.", details={"sources": definitions}))
    return {
        "contributors": len(copies),
        "registrations": len(registrations),
        "duplicate_ids": duplicate_ids,
        "type_conflicts": type_conflicts,
        "invalid_base_itemtags": invalid_base_tags,
    }


def inspect_chat(copies: list[dict[str, Any]], order: dict[str, int], findings: list[Finding]) -> dict[str, Any]:
    if not copies:
        return {"copies": 0}
    effective = max(copies, key=lambda entry: order.get(entry["mod_id"], -1))
    text = read_text(effective["path"])
    functions = sorted(set(CHAT_FUNCTION_RE.findall(text)))
    findings.append(Finding(
        "warning", "ISCHAT_FULL_REPLACEMENT",
        f"{effective['mod_id']} aporta el ISChat.lua completo; debe compararse con el vanilla exacto después de cada actualización.",
        effective["rel"], effective["mod_id"],
        {"layer": effective["layer"], "lines": len(text.splitlines()), "sha256": effective["sha256"], "functions": len(functions)},
    ))
    return {
        "copies": len(copies),
        "effective_mod": effective["mod_id"],
        "effective_path": effective["rel"],
        "active_layer": effective["layer"],
        "lines": len(text.splitlines()),
        "functions": functions,
    }


def declaration_blocks(text: str) -> Iterable[tuple[str, str, str]]:
    lines = text.splitlines()
    module = "?"
    depth = 0
    index = 0
    while index < len(lines):
        raw = lines[index]
        clean = raw.split("//", 1)[0]
        module_match = MODULE_RE.match(clean)
        if module_match and depth == 0:
            module = module_match.group(1)
        declaration = DECL_RE.match(clean) if depth == 1 else None
        if declaration:
            kind, name = declaration.group(1).lower(), declaration.group(2)
            block_lines = [raw]
            cursor = index
            opened = clean.count("{")
            balance = clean.count("{") - clean.count("}")
            while opened == 0 and cursor + 1 < len(lines):
                cursor += 1
                block_lines.append(lines[cursor])
                candidate = lines[cursor].split("//", 1)[0]
                opened += candidate.count("{")
                balance += candidate.count("{") - candidate.count("}")
            while opened > 0 and balance > 0 and cursor + 1 < len(lines):
                cursor += 1
                block_lines.append(lines[cursor])
                candidate = lines[cursor].split("//", 1)[0]
                balance += candidate.count("{") - candidate.count("}")
            yield kind, f"{module}.{name}", canonical_text("\n".join(block_lines))
        depth += clean.count("{") - clean.count("}")
        depth = max(depth, 0)
        index += 1


def scan_symbols(mods: dict[str, dict[str, Any]], order: list[str], root: Path, findings: list[Finding]) -> dict[str, Any]:
    symbols: dict[str, list[dict[str, str]]] = defaultdict(list)
    for mod_id in order:
        mod = mods.get(mod_id)
        if not mod:
            continue
        for virtual, file in active_files(mod).items():
            if not virtual.startswith("media/scripts/") or file["path"].suffix.lower() != ".txt":
                continue
            for kind, full_name, body in declaration_blocks(read_text(file["path"])):
                symbols[f"{kind}:{full_name}"].append({
                    "mod": mod_id,
                    "path": rel(file["path"], root),
                    "hash": hashlib.sha256(body.encode("utf-8")).hexdigest(),
                })
    different_duplicates = 0
    identical_duplicates = 0
    same_mod_duplicates = 0
    for symbol, definitions in symbols.items():
        owners = {d["mod"] for d in definitions}
        hashes = {d["hash"] for d in definitions}
        if len(definitions) > 1 and len(owners) == 1:
            same_mod_duplicates += 1
            if len(hashes) > 1:
                findings.append(Finding("error", "SCRIPT_SYMBOL_DUPLICATED_IN_MOD", f"{symbol} se declara varias veces con contenido distinto dentro de {next(iter(owners))}.", details={"sources": definitions[:20]}))
        elif len(owners) > 1 and len(hashes) > 1:
            different_duplicates += 1
            findings.append(Finding("error", "SCRIPT_SYMBOL_CONFLICT", f"{symbol} tiene definiciones distintas en varios mods.", details={"sources": definitions[:20]}))
        elif len(owners) > 1:
            identical_duplicates += 1
    critical = "entity:Base.IDBFS_LiquidBarrelRack"
    if critical not in symbols:
        findings.append(Finding("error", "CRITICAL_ENTITY_MISSING", "Falta Base.IDBFS_LiquidBarrelRack en los scripts activos."))
    return {
        "symbols": len(symbols),
        "different_cross_mod_duplicates": different_duplicates,
        "identical_cross_mod_duplicates": identical_duplicates,
        "same_mod_duplicates": same_mod_duplicates,
        "critical_entity_present": critical in symbols,
        "critical_entity_sources": symbols.get(critical, []),
    }


def audit(root: Path, config: dict[str, Any]) -> tuple[list[Finding], dict[str, Any]]:
    findings: list[Finding] = []
    build = str(config["build"])
    mods_order = [str(value) for value in config.get("mods", [])]
    external = {str(value) for value in config.get("external_mods", [])}
    order_index = {mod_id: index for index, mod_id in enumerate(mods_order)}
    mods = discover_mods(root, build)

    files_by_virtual: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for mod_id in mods_order:
        if mod_id in external or mod_id not in mods:
            continue
        for virtual, file in active_files(mods[mod_id]).items():
            files_by_virtual[virtual].append({
                **file,
                "mod_id": mod_id,
                "rel": rel(file["path"], root),
                "order": order_index[mod_id],
            })

    sensitive_report: dict[str, Any] = {}
    known_file_guids: set[str] = set()
    clothing_references: set[str] = set()
    for virtual in SENSITIVE:
        copies = files_by_virtual.get(virtual, [])
        base = {
            "mode": "cumulative" if virtual in CUMULATIVE else "replacement",
            "copies": len(copies),
            "contributors": [entry["mod_id"] for entry in sorted(copies, key=lambda e: e["order"])],
            "paths": [entry["rel"] for entry in sorted(copies, key=lambda e: e["order"])],
            "unique_hashes": len({entry["sha256"] for entry in copies}),
        }
        if virtual == "media/sandbox-options.txt":
            base["semantic"] = inspect_sandbox(copies, findings)
        elif virtual == "media/registries.lua":
            base["semantic"] = inspect_registries(copies, findings)
        elif virtual == "media/fileguidtable.xml":
            semantic, known_file_guids = inspect_fileguid(copies, findings)
            base["semantic"] = semantic
        elif virtual == "media/clothing/clothing.xml":
            semantic, clothing_references = inspect_clothing(copies, findings)
            base["semantic"] = semantic
        else:
            base["semantic"] = inspect_chat(copies, order_index, findings)
        sensitive_report[virtual] = base

    collisions = {path: copies for path, copies in files_by_virtual.items() if len({entry["mod_id"] for entry in copies}) > 1}
    expected_translation_collisions = sum(path.startswith("media/lua/shared/translate/") for path in collisions)
    keep_collisions = sum(path.endswith("/.keep") for path in collisions)
    other_collisions = len(collisions) - expected_translation_collisions - keep_collisions

    symbols = scan_symbols(mods, mods_order, root, findings)
    stats = {
        "build": build,
        "internal_mods_discovered": len(mods),
        "external_mods": sorted(external),
        "active_virtual_files": len(files_by_virtual),
        "shared_virtual_paths": len(collisions),
        "translation_shared_paths": expected_translation_collisions,
        "keep_shared_paths": keep_collisions,
        "other_shared_paths": other_collisions,
        "sensitive": sensitive_report,
        "fileguid_known_guids": len(known_file_guids),
        "clothing_item_guid_references": len(clothing_references),
        "clothing_refs_not_in_mod_fileguid": len(clothing_references - known_file_guids),
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
        f"- Rutas compartidas entre mods: **{stats['shared_virtual_paths']}**",
        f"- Rutas compartidas de traducción: **{stats['translation_shared_paths']}**",
        f"- Rutas `.keep` compartidas: **{stats['keep_shared_paths']}**",
        f"- Otras rutas compartidas: **{stats['other_shared_paths']}**",
        f"- Errores: **{stats['errors']}**",
        f"- Advertencias: **{stats['warnings']}**",
        "",
        "Las rutas compartidas no se consideran por sí mismas un error. Solo se elevan hallazgos cuando el formato permite demostrar un ID, GUID, opción o símbolo incompatible.",
        "",
        "## Archivos globales sensibles",
        "",
        "| Ruta | Modo | Copias | Contribuyentes | Resultado semántico |",
        "|---|---|---:|---|---|",
    ]
    for virtual, data in stats["sensitive"].items():
        semantic = data.get("semantic", {})
        summary = ", ".join(f"{k}={v}" for k, v in semantic.items() if isinstance(v, (str, int, bool))) or "—"
        out.append(f"| `{virtual}` | {data['mode']} | {data['copies']} | {' → '.join(data['contributors']) or '—'} | {summary} |")
    out.extend([
        "",
        "## Símbolos persistentes",
        "",
        f"- Símbolos analizados: **{stats['symbols']['symbols']}**",
        f"- Duplicados diferentes entre mods: **{stats['symbols']['different_cross_mod_duplicates']}**",
        f"- Duplicados idénticos entre mods: **{stats['symbols']['identical_cross_mod_duplicates']}**",
        f"- Duplicados dentro del mismo mod: **{stats['symbols']['same_mod_duplicates']}**",
        f"- `Base.IDBFS_LiquidBarrelRack`: **{'presente' if stats['symbols']['critical_entity_present'] else 'ausente'}**",
        "",
        "## Hallazgos",
        "",
    ])
    if not findings:
        out.append("No se encontraron conflictos demostrables.")
    for finding in sorted(findings, key=lambda item: (0 if item.severity == "error" else 1, item.code, item.path or "")):
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
        "## Nota sobre GUID de ropa",
        "",
        "Las referencias de ropa que no aparecen en los `fileGuidTable.xml` de los mods no se marcan como error porque pueden pertenecer al juego base. La comprobación definitiva requiere comparar también con el `fileGuidTable` vanilla de Build 42.20.",
        "",
        "## Límite de la auditoría",
        "",
        "Esta pasada no sustituye una conexión real. La paridad GitHub/Workshop/servidor/cliente se verifica con `generar_manifest_despliegue.py` y los logs con `validar_logs_runtime.py`.",
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
        json.dumps({"stats": stats, "findings": [asdict(item) for item in findings]}, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    args.output.with_suffix(".md").write_text(markdown(findings, stats), encoding="utf-8")
    print(f"Parte 3: {stats['errors']} errores, {stats['warnings']} advertencias")
    return 1 if stats["errors"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
