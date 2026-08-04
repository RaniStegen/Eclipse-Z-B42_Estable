#!/usr/bin/env python3
"""Auditor estático del modpack Eclipse-Z para Project Zomboid Build 42.

No modifica archivos. Comprueba estructura Workshop, IDs de mods, dependencias,
JSON, traducciones, marcadores de formato, duplicados y sobrescrituras sensibles.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from collections import defaultdict
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Any, Iterable


MOJIBAKE_TOKENS = ("Ã", "Â", "â", "ð", "�")
BACKUP_MARKERS = (
    ".bak",
    ".backup",
    ".old",
    "_old",
    "antes_",
    "backup_",
    ".disabled",
)
SENSITIVE_VIRTUAL_PATHS = {
    "media/lua/client/chat/ischat.lua",
    "media/registries.lua",
    "media/clothing/clothing.xml",
    "media/fileguidtable.xml",
    "media/sandbox-options.txt",
}
VERSION_RE = re.compile(r"^\d+(?:\.\d+)*$")
ENTITY_RE = re.compile(r"\bentity\s+([A-Za-z0-9_.-]+)")
MODULE_RE = re.compile(r"\bmodule\s+([A-Za-z0-9_.-]+)")
PERCENT_TOKEN_RE = re.compile(r"%(?:\d+|[A-Za-z])")


@dataclass
class Finding:
    severity: str
    code: str
    message: str
    path: str | None = None
    details: dict[str, Any] | None = None


class DuplicateKeyError(ValueError):
    pass


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Audita MODPACK-ACTUAL-EN-SERVIDOR")
    parser.add_argument(
        "root",
        nargs="?",
        type=Path,
        default=Path(__file__).resolve().parents[1],
        help="Raíz del modpack (por defecto, la carpeta superior a _AUDITORIA)",
    )
    parser.add_argument(
        "--config",
        type=Path,
        default=Path(__file__).with_name("configuracion_servidor_actual.json"),
        help="Configuración de referencia del servidor",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(__file__).with_name("resultado_auditoria"),
        help="Prefijo de salida; genera .json y .md",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Devuelve error también cuando solo existen advertencias",
    )
    return parser.parse_args()


def norm(path: Path, root: Path) -> str:
    try:
        return path.relative_to(root).as_posix()
    except ValueError:
        return path.as_posix()


def parse_key_value_file(path: Path) -> dict[str, list[str]]:
    result: dict[str, list[str]] = defaultdict(list)
    try:
        text = path.read_text(encoding="utf-8-sig", errors="strict")
    except UnicodeDecodeError:
        text = path.read_text(encoding="cp1252", errors="replace")
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith(("#", "--")) or "=" not in line:
            continue
        key, value = line.split("=", 1)
        result[key.strip()].append(value.strip())
    return dict(result)


def split_values(values: Iterable[str]) -> list[str]:
    out: list[str] = []
    for value in values:
        for part in re.split(r"[;,]", value):
            item = part.strip()
            if item:
                out.append(item)
    return out


def version_key(name: str) -> tuple[int, ...]:
    if not VERSION_RE.match(name):
        return (-1,)
    return tuple(int(x) for x in name.split("."))


def duplicate_guard(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    data: dict[str, Any] = {}
    duplicates: list[str] = []
    for key, value in pairs:
        if key in data:
            duplicates.append(key)
        data[key] = value
    if duplicates:
        unique = sorted(set(duplicates))
        raise DuplicateKeyError(", ".join(unique[:25]))
    return data


def read_json(path: Path) -> Any:
    return json.loads(
        path.read_text(encoding="utf-8-sig"),
        object_pairs_hook=duplicate_guard,
    )


def walk_strings(value: Any, prefix: str = "") -> Iterable[tuple[str, str]]:
    if isinstance(value, dict):
        for key, child in value.items():
            child_prefix = f"{prefix}.{key}" if prefix else str(key)
            if isinstance(key, str):
                yield f"{child_prefix}.__key__", key
            yield from walk_strings(child, child_prefix)
    elif isinstance(value, list):
        for index, child in enumerate(value):
            yield from walk_strings(child, f"{prefix}[{index}]")
    elif isinstance(value, str):
        yield prefix, value


def find_mod_roots(root: Path) -> list[Path]:
    roots: list[Path] = []
    for mods_dir in root.glob("*/Contents/mods"):
        if not mods_dir.is_dir():
            continue
        roots.extend(sorted(p for p in mods_dir.iterdir() if p.is_dir()))
    return roots


def mod_info_candidates(mod_root: Path) -> list[Path]:
    candidates = sorted(mod_root.rglob("mod.info"))
    return [p for p in candidates if "media" not in {part.lower() for part in p.parts}]


def active_mod_info(infos: list[Path], mod_root: Path) -> Path | None:
    direct = mod_root / "mod.info"
    if direct in infos:
        return direct
    versioned: list[tuple[tuple[int, ...], Path]] = []
    for info in infos:
        try:
            parent = info.relative_to(mod_root).parent
        except ValueError:
            continue
        if len(parent.parts) == 1 and VERSION_RE.match(parent.name):
            versioned.append((version_key(parent.name), info))
    if versioned:
        return max(versioned, key=lambda x: x[0])[1]
    return infos[0] if infos else None


def virtual_path(file: Path) -> str | None:
    parts = list(file.parts)
    lower = [p.lower() for p in parts]
    try:
        index = lower.index("media")
    except ValueError:
        return None
    return "/".join(lower[index:])


def locate_translation_dir(root: Path, mod_id: str) -> Path | None:
    candidates: list[tuple[tuple[int, ...], Path]] = []
    for mod_root in find_mod_roots(root):
        infos = mod_info_candidates(mod_root)
        ids: set[str] = set()
        for info in infos:
            parsed = parse_key_value_file(info)
            ids.update(parsed.get("id", []))
        if mod_id not in ids:
            continue
        for es_dir in mod_root.rglob("Translate/ES"):
            rel = es_dir.relative_to(mod_root)
            version = next((p for p in rel.parts if VERSION_RE.match(p)), "0")
            candidates.append((version_key(version), es_dir))
    return max(candidates, key=lambda x: x[0])[1] if candidates else None


def load_translation_maps(es_dir: Path) -> dict[str, dict[str, Any]]:
    maps: dict[str, dict[str, Any]] = {}
    for path in sorted(es_dir.glob("*.json")):
        try:
            data = read_json(path)
        except (OSError, json.JSONDecodeError, DuplicateKeyError):
            continue
        if isinstance(data, dict):
            maps[path.name.lower()] = data
    return maps


def audit(root: Path, config: dict[str, Any]) -> tuple[list[Finding], dict[str, Any]]:
    findings: list[Finding] = []
    stats: dict[str, Any] = {
        "workshop_items": 0,
        "mod_directories": 0,
        "mod_ids": 0,
        "json_files": 0,
        "translation_json_files": 0,
        "sensitive_overrides": 0,
    }

    if not root.is_dir():
        findings.append(Finding("error", "ROOT_NOT_FOUND", "No existe la raíz del modpack", str(root)))
        return findings, stats

    # Workshop.
    workshop_by_id: dict[str, list[Path]] = defaultdict(list)
    for workshop in sorted(root.glob("*/workshop.txt")):
        parsed = parse_key_value_file(workshop)
        item_ids = parsed.get("id", [])
        if not item_ids:
            findings.append(Finding("error", "WORKSHOP_ID_MISSING", "workshop.txt sin id", norm(workshop, root)))
            continue
        for item_id in item_ids:
            workshop_by_id[item_id].append(workshop)
    stats["workshop_items"] = sum(len(v) for v in workshop_by_id.values())

    expected_workshop = [str(x) for x in config.get("workshop_items", [])]
    for item_id in expected_workshop:
        if item_id not in workshop_by_id:
            findings.append(Finding("error", "WORKSHOP_ITEM_MISSING", f"Falta el Workshop Item {item_id}"))
    for item_id, paths in sorted(workshop_by_id.items()):
        if len(paths) > 1:
            findings.append(Finding(
                "error",
                "WORKSHOP_ID_DUPLICATED",
                f"El Workshop ID {item_id} aparece {len(paths)} veces",
                details={"paths": [norm(p, root) for p in paths]},
            ))
        if expected_workshop and item_id not in expected_workshop:
            findings.append(Finding("warning", "WORKSHOP_ITEM_UNEXPECTED", f"Workshop Item no incluido en la configuración: {item_id}", norm(paths[0], root)))

    # Mods y mod.info.
    mod_roots = find_mod_roots(root)
    stats["mod_directories"] = len(mod_roots)
    ids_to_roots: dict[str, list[Path]] = defaultdict(list)
    mod_dependencies: dict[str, set[str]] = defaultdict(set)
    mod_active_info: dict[Path, Path | None] = {}

    for mod_root in mod_roots:
        infos = mod_info_candidates(mod_root)
        mod_active_info[mod_root] = active_mod_info(infos, mod_root)
        if not infos:
            findings.append(Finding("error", "MOD_INFO_MISSING", "Carpeta de mod sin mod.info", norm(mod_root, root)))
            continue

        seen_ids: set[str] = set()
        for info in infos:
            parsed = parse_key_value_file(info)
            ids = parsed.get("id", [])
            if len(ids) != 1:
                findings.append(Finding("error", "MOD_ID_INVALID", "mod.info debe contener un único id", norm(info, root), {"ids": ids}))
                continue
            mod_id = ids[0]
            seen_ids.add(mod_id)
            for key in ("require", "requires", "requiredMods"):
                mod_dependencies[mod_id].update(split_values(parsed.get(key, [])))

            for required_key in ("name", "id"):
                if not parsed.get(required_key):
                    findings.append(Finding("error", "MOD_INFO_FIELD_MISSING", f"Falta {required_key}= en mod.info", norm(info, root)))

        if len(seen_ids) > 1:
            findings.append(Finding(
                "error",
                "MOD_ID_INCONSISTENT",
                "La misma carpeta declara IDs diferentes según la versión",
                norm(mod_root, root),
                {"ids": sorted(seen_ids)},
            ))
        for mod_id in seen_ids:
            ids_to_roots[mod_id].append(mod_root)
            if mod_root.name != mod_id:
                findings.append(Finding(
                    "warning",
                    "MOD_FOLDER_ID_MISMATCH",
                    f"La carpeta {mod_root.name} declara id={mod_id}",
                    norm(mod_root, root),
                ))

        # El mod.info raíz no es obligatorio en todas las estructuras B42, pero
        # ayuda a evitar detecciones inconsistentes en servidores dedicados.
        if not (mod_root / "mod.info").exists():
            findings.append(Finding(
                "warning",
                "ROOT_MOD_INFO_MISSING",
                "No existe mod.info en la raíz del mod; revisar detección en dedicado",
                norm(mod_root, root),
            ))

    stats["mod_ids"] = len(ids_to_roots)
    for mod_id, roots in sorted(ids_to_roots.items()):
        if len(roots) > 1:
            findings.append(Finding(
                "error",
                "MOD_ID_DUPLICATED",
                f"El ID {mod_id} existe en {len(roots)} carpetas",
                details={"paths": [norm(p, root) for p in roots]},
            ))

    expected_mods = [str(x) for x in config.get("mods", [])]
    expected_set = set(expected_mods)
    for mod_id in expected_mods:
        if mod_id not in ids_to_roots:
            findings.append(Finding("error", "SERVER_MOD_MISSING", f"Mods= contiene {mod_id}, pero no se encontró ese ID"))
    for mod_id in sorted(set(ids_to_roots) - expected_set):
        findings.append(Finding("warning", "SERVER_MOD_NOT_LISTED", f"Existe el mod {mod_id}, pero no está en la lista Mods="))

    tail = [str(x) for x in config.get("required_tail_order", [])]
    if tail and expected_mods[-len(tail):] != tail:
        findings.append(Finding(
            "error",
            "MOD_ORDER_TAIL_INVALID",
            "El final de Mods= no respeta el orden obligatorio",
            details={"expected": tail, "actual": expected_mods[-len(tail):]},
        ))

    all_ids = set(ids_to_roots)
    for mod_id, dependencies in sorted(mod_dependencies.items()):
        for dependency in sorted(dependencies):
            if dependency and dependency not in all_ids:
                findings.append(Finding(
                    "error",
                    "REQUIRED_MOD_MISSING",
                    f"{mod_id} requiere {dependency}, pero ese ID no existe en el modpack",
                ))

    # Map folder.
    expected_map = str(config.get("map_folder", "")).strip()
    if expected_map:
        map_matches = [p for p in root.rglob(expected_map) if p.is_dir()]
        if not map_matches:
            findings.append(Finding("warning", "MAP_FOLDER_NOT_FOUND", f"No se encontró la carpeta de mapa {expected_map}"))

    # Archivos de copia y JSON.
    virtual_owners: dict[str, set[str]] = defaultdict(set)
    entities: dict[str, list[str]] = defaultdict(list)

    for mod_root in mod_roots:
        info = mod_active_info.get(mod_root)
        owner = mod_root.name
        if info:
            parsed = parse_key_value_file(info)
            owner = parsed.get("id", [owner])[0]

        for file in mod_root.rglob("*"):
            if not file.is_file():
                continue
            lower_name = file.name.lower()
            if any(marker in lower_name for marker in BACKUP_MARKERS):
                findings.append(Finding("warning", "BACKUP_FILE_ACTIVE", "Archivo de copia o desactivado dentro de Contents", norm(file, root)))

            vp = virtual_path(file)
            if vp:
                virtual_owners[vp].add(owner)

            if file.suffix.lower() == ".json":
                stats["json_files"] += 1
                try:
                    data = read_json(file)
                except DuplicateKeyError as exc:
                    findings.append(Finding("error", "JSON_DUPLICATE_KEYS", f"Claves JSON duplicadas: {exc}", norm(file, root)))
                    continue
                except json.JSONDecodeError as exc:
                    findings.append(Finding("error", "JSON_INVALID", f"JSON inválido: línea {exc.lineno}, columna {exc.colno}: {exc.msg}", norm(file, root)))
                    continue
                except UnicodeDecodeError as exc:
                    findings.append(Finding("error", "JSON_ENCODING_INVALID", f"JSON no es UTF-8: {exc}", norm(file, root)))
                    continue
                except OSError as exc:
                    findings.append(Finding("error", "JSON_READ_ERROR", str(exc), norm(file, root)))
                    continue

                path_lower = file.as_posix().lower()
                is_spanish_translation = "/translate/es/" in path_lower
                if is_spanish_translation:
                    stats["translation_json_files"] += 1
                    for key_path, text in walk_strings(data):
                        bad = [token for token in MOJIBAKE_TOKENS if token in text]
                        if bad:
                            findings.append(Finding(
                                "error",
                                "TRANSLATION_MOJIBAKE",
                                f"Texto con codificación dañada en {key_path}",
                                norm(file, root),
                                {"tokens": bad, "value": text[:300]},
                            ))

                        tokens = PERCENT_TOKEN_RE.findall(text)
                        dangerous = sorted({token for token in tokens if not token[1:].isdigit()})
                        if dangerous:
                            findings.append(Finding(
                                "warning",
                                "TRANSLATION_PRINTF_TOKEN",
                                f"Marcador de formato tipo printf en {key_path}: {', '.join(dangerous)}",
                                norm(file, root),
                                {"value": text[:300]},
                            ))

                    if isinstance(data, dict) and "UI_servers_refresh_timer" in data:
                        value = str(data["UI_servers_refresh_timer"])
                        if "%1" not in value or "%d" in value:
                            findings.append(Finding(
                                "error",
                                "MULTIPLAYER_REFRESH_FORMAT",
                                "UI_servers_refresh_timer debe usar %1 y nunca %d",
                                norm(file, root),
                                {"value": value},
                            ))

            if file.suffix.lower() in {".txt", ".lua"} and "media/scripts" in file.as_posix().lower():
                try:
                    text = file.read_text(encoding="utf-8-sig", errors="ignore")
                except OSError:
                    continue
                module_match = MODULE_RE.search(text)
                module_name = module_match.group(1) if module_match else "?"
                for match in ENTITY_RE.finditer(text):
                    entity = f"{module_name}.{match.group(1)}"
                    entities[entity].append(norm(file, root))

    for vp, owners in sorted(virtual_owners.items()):
        if len(owners) <= 1:
            continue
        severity = "warning"
        code = "VIRTUAL_PATH_OVERRIDDEN"
        if vp in SENSITIVE_VIRTUAL_PATHS:
            code = "SENSITIVE_FILE_OVERRIDDEN"
            stats["sensitive_overrides"] += 1
        findings.append(Finding(
            severity,
            code,
            f"La ruta virtual {vp} es aportada por varios mods",
            details={"mods": sorted(owners)},
        ))

    for entity, paths in sorted(entities.items()):
        unique_paths = sorted(set(paths))
        if len(unique_paths) > 1:
            findings.append(Finding(
                "error",
                "ENTITY_DUPLICATED",
                f"La entidad {entity} está definida en varios archivos",
                details={"paths": unique_paths},
            ))

    # Separación entre traducción base y traducción de mods.
    base_es = locate_translation_dir(root, "ECZ_Idioma")
    mods_es = locate_translation_dir(root, "ECZ_Mods")
    if base_es and mods_es:
        base_maps = load_translation_maps(base_es)
        mods_maps = load_translation_maps(mods_es)
        overlap_total = 0
        conflicts_total = 0
        samples: list[dict[str, Any]] = []
        for filename in sorted(set(base_maps) & set(mods_maps)):
            base_data = base_maps[filename]
            mods_data = mods_maps[filename]
            overlap = sorted(set(base_data) & set(mods_data))
            conflicts = [key for key in overlap if base_data[key] != mods_data[key]]
            overlap_total += len(overlap)
            conflicts_total += len(conflicts)
            for key in conflicts[:5]:
                if len(samples) >= 25:
                    break
                samples.append({
                    "file": filename,
                    "key": key,
                    "base": base_data[key],
                    "mods": mods_data[key],
                })
        if overlap_total:
            findings.append(Finding(
                "warning",
                "BASE_MOD_TRANSLATION_OVERLAP",
                f"ECZ_Mods todavía comparte {overlap_total} claves con ECZ_Idioma; {conflicts_total} tienen valores distintos",
                details={"conflict_samples": samples},
            ))
    else:
        findings.append(Finding(
            "warning",
            "TRANSLATION_PACKAGE_NOT_FOUND",
            "No se pudo localizar ECZ_Idioma o ECZ_Mods para comprobar solapamientos",
        ))

    return findings, stats


def render_markdown(root: Path, config: dict[str, Any], findings: list[Finding], stats: dict[str, Any]) -> str:
    counts = defaultdict(int)
    for finding in findings:
        counts[finding.severity] += 1

    lines = [
        "# Auditoría del modpack Eclipse-Z",
        "",
        f"- Raíz: `{root}`",
        f"- Build configurada: `{config.get('build', 'desconocida')}`",
        f"- Errores: **{counts['error']}**",
        f"- Advertencias: **{counts['warning']}**",
        f"- Informativos: **{counts['info']}**",
        "",
        "## Estadísticas",
        "",
    ]
    for key, value in stats.items():
        lines.append(f"- `{key}`: {value}")

    lines.extend(["", "## Hallazgos", ""])
    if not findings:
        lines.append("No se encontraron problemas.")
    else:
        order = {"error": 0, "warning": 1, "info": 2}
        for finding in sorted(findings, key=lambda f: (order.get(f.severity, 9), f.code, f.path or "")):
            icon = {"error": "❌", "warning": "⚠️", "info": "ℹ️"}.get(finding.severity, "•")
            lines.append(f"### {icon} `{finding.code}`")
            lines.append("")
            lines.append(finding.message)
            if finding.path:
                lines.append("")
                lines.append(f"Ruta: `{finding.path}`")
            if finding.details:
                lines.append("")
                lines.append("```json")
                lines.append(json.dumps(finding.details, ensure_ascii=False, indent=2, default=str))
                lines.append("```")
            lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    args = parse_args()
    root = args.root.resolve()
    config_path = args.config.resolve()
    output_prefix = args.output.resolve()

    try:
        config = json.loads(config_path.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"ERROR: no se pudo leer la configuración: {exc}", file=sys.stderr)
        return 2

    findings, stats = audit(root, config)
    payload = {
        "root": str(root),
        "config": str(config_path),
        "stats": stats,
        "findings": [asdict(f) for f in findings],
    }

    output_prefix.parent.mkdir(parents=True, exist_ok=True)
    json_path = output_prefix.with_suffix(".json")
    md_path = output_prefix.with_suffix(".md")
    json_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    md_path.write_text(render_markdown(root, config, findings, stats), encoding="utf-8")

    errors = sum(1 for f in findings if f.severity == "error")
    warnings = sum(1 for f in findings if f.severity == "warning")
    print(f"Auditoría terminada: {errors} errores, {warnings} advertencias")
    print(f"Informe JSON: {json_path}")
    print(f"Informe Markdown: {md_path}")

    if errors or (args.strict and warnings):
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
