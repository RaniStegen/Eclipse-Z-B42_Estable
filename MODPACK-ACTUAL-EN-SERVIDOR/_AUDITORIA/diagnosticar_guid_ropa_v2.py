#!/usr/bin/env python3
"""Diagnóstico GUID/outfits con distinción de género.

Una misma combinación nombre+GUID puede existir una vez para hombre y otra
para mujer. Solo se considera duplicado estructural cuando se repite dentro
del mismo mod, archivo y género.
"""
from __future__ import annotations

import argparse
import json
import re
import xml.etree.ElementTree as ET
from collections import defaultdict
from pathlib import Path

VERSION_RE = re.compile(r"^\d+(?:\.\d+)*$")


def args():
    p = argparse.ArgumentParser()
    p.add_argument("root", nargs="?", type=Path, default=Path(__file__).resolve().parents[1])
    p.add_argument("--config", type=Path, default=Path(__file__).with_name("configuracion_servidor_actual.json"))
    p.add_argument("--output", required=True, type=Path)
    return p.parse_args()


def vt(value):
    parts = tuple(map(int, value.split(".")))
    return parts + (0,) * max(0, 4 - len(parts))


def read(path):
    raw = path.read_bytes()
    for encoding in ("utf-8-sig", "utf-16", "cp1252"):
        try:
            return raw.decode(encoding)
        except UnicodeError:
            pass
    return raw.decode("utf-8", errors="replace")


def parse_id(path):
    for raw in read(path).splitlines():
        line = raw.strip()
        if line.startswith("id="):
            return line.split("=", 1)[1].strip()
    return None


def discover(root, build):
    found = {}
    for mods_dir in root.glob("*/Contents/mods"):
        if not mods_dir.is_dir():
            continue
        for mod_root in mods_dir.iterdir():
            if not mod_root.is_dir():
                continue
            ids = set()
            for info in mod_root.rglob("mod.info"):
                if "media" in {part.lower() for part in info.relative_to(mod_root).parts}:
                    continue
                mod_id = parse_id(info)
                if mod_id:
                    ids.add(mod_id)
            if len(ids) != 1:
                continue
            mod_id = next(iter(ids))
            versions = sorted(
                (p for p in mod_root.iterdir() if p.is_dir() and VERSION_RE.fullmatch(p.name) and vt(p.name) <= vt(build)),
                key=lambda p: vt(p.name),
            )
            layers = []
            if (mod_root / "media").is_dir():
                layers.append(mod_root / "media")
            if (mod_root / "common" / "media").is_dir():
                layers.append(mod_root / "common" / "media")
            if versions and (versions[-1] / "media").is_dir():
                layers.append(versions[-1] / "media")
            active = {}
            for layer in layers:
                for path in layer.rglob("*"):
                    if path.is_file():
                        active[("media/" + path.relative_to(layer).as_posix()).lower()] = path
            found[mod_id] = {"root": mod_root, "files": active}
    return found


def child_map(elem):
    return {child.tag.lower(): (child.text or "").strip() for child in list(elem)}


def serializable_key(parts):
    return " | ".join(str(value) for value in parts)


def main():
    options = args()
    root = options.root.resolve()
    config = json.loads(options.config.read_text(encoding="utf-8-sig"))
    order = list(map(str, config["mods"]))
    mods = discover(root, str(config["build"]))

    file_entries = []
    outfit_entries = []
    references = defaultdict(list)

    for mod_id in order:
        if mod_id not in mods:
            continue
        fileguid = mods[mod_id]["files"].get("media/fileguidtable.xml")
        if fileguid:
            xml_root = ET.parse(fileguid).getroot()
            for elem in xml_root.iter():
                values = child_map(elem)
                path = values.get("path")
                guid = values.get("guid")
                if path and guid:
                    file_entries.append({
                        "mod": mod_id,
                        "file": fileguid.relative_to(root).as_posix(),
                        "path": path.replace("\\", "/").lower(),
                        "guid": guid.lower(),
                    })

        clothing = mods[mod_id]["files"].get("media/clothing/clothing.xml")
        if clothing:
            xml_root = ET.parse(clothing).getroot()
            for gender, tag in (("female", "m_FemaleOutfits"), ("male", "m_MaleOutfits")):
                for outfit in xml_root.iter(tag):
                    name = (outfit.findtext("m_Name") or "").strip()
                    guid = (outfit.findtext("m_Guid") or "").strip().lower()
                    if not name and not guid:
                        continue
                    entry = {
                        "mod": mod_id,
                        "file": clothing.relative_to(root).as_posix(),
                        "gender": gender,
                        "name": name,
                        "guid": guid,
                    }
                    outfit_entries.append(entry)
                    for node in outfit.iter("itemGUID"):
                        item_guid = (node.text or "").strip().lower()
                        if item_guid:
                            references[item_guid].append({**entry, "outfit_guid": guid})

    by_path = defaultdict(list)
    by_guid = defaultdict(list)
    for entry in file_entries:
        by_path[entry["path"]].append(entry)
        by_guid[entry["guid"]].append(entry)

    path_conflicts = {
        path: entries for path, entries in by_path.items()
        if len({entry["guid"] for entry in entries}) > 1
    }
    guid_conflicts = {
        guid: entries for guid, entries in by_guid.items()
        if len({entry["path"] for entry in entries}) > 1
    }

    by_outfit_guid = defaultdict(list)
    by_same_gender_name = defaultdict(list)
    by_same_gender_guid = defaultdict(list)
    by_name_guid = defaultdict(list)
    for entry in outfit_entries:
        if entry["guid"]:
            by_outfit_guid[entry["guid"]].append(entry)
            by_same_gender_guid[(entry["mod"], entry["file"], entry["gender"], entry["guid"])].append(entry)
        if entry["name"]:
            by_same_gender_name[(entry["mod"], entry["file"], entry["gender"], entry["name"])].append(entry)
        if entry["name"] and entry["guid"]:
            by_name_guid[(entry["mod"], entry["file"], entry["name"], entry["guid"])].append(entry)

    outfit_guid_conflicts = {
        guid: entries for guid, entries in by_outfit_guid.items()
        if len({entry["name"] for entry in entries}) > 1
    }
    duplicate_names_same_gender = {
        serializable_key(key): entries for key, entries in by_same_gender_name.items()
        if len(entries) > 1
    }
    duplicate_guids_same_gender = {
        serializable_key(key): entries for key, entries in by_same_gender_guid.items()
        if len(entries) > 1
    }
    legitimate_cross_gender_pairs = {
        serializable_key(key): entries for key, entries in by_name_guid.items()
        if {entry["gender"] for entry in entries} == {"male", "female"}
        and len(entries) == 2
    }

    result = {
        "path_conflicts": path_conflicts,
        "guid_conflicts": guid_conflicts,
        "outfit_guid_conflicts": outfit_guid_conflicts,
        "duplicate_outfit_names_same_gender": duplicate_names_same_gender,
        "duplicate_outfit_guids_same_gender": duplicate_guids_same_gender,
        "legitimate_cross_gender_pairs": legitimate_cross_gender_pairs,
        "references": {
            guid: references.get(guid, [])
            for guid in set(guid_conflicts) | set(outfit_guid_conflicts)
        },
        "summary": {
            "file_path_conflicts": len(path_conflicts),
            "file_guid_conflicts": len(guid_conflicts),
            "outfit_guid_conflicts": len(outfit_guid_conflicts),
            "same_gender_name_duplicates": len(duplicate_names_same_gender),
            "same_gender_guid_duplicates": len(duplicate_guids_same_gender),
            "legitimate_cross_gender_pairs": len(legitimate_cross_gender_pairs),
        },
    }

    options.output.parent.mkdir(parents=True, exist_ok=True)
    options.output.with_suffix(".json").write_text(
        json.dumps(result, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    lines = [
        "# Diagnóstico de GUID y outfits",
        "",
        "## Resumen",
        "",
    ]
    lines.extend(f"- `{key}`: {value}" for key, value in result["summary"].items())
    for title, key in (
        ("Conflictos ruta → GUID", "path_conflicts"),
        ("Conflictos GUID → ruta", "guid_conflicts"),
        ("GUID compartidos por outfits distintos", "outfit_guid_conflicts"),
        ("Nombres repetidos dentro del mismo género", "duplicate_outfit_names_same_gender"),
        ("GUID repetidos dentro del mismo género", "duplicate_outfit_guids_same_gender"),
    ):
        lines.extend(["", f"## {title}", ""])
        data = result[key]
        if not data:
            lines.append("Ninguno.")
        for identifier, entries in data.items():
            lines.extend([
                f"### `{identifier}`",
                "",
                "```json",
                json.dumps(entries, ensure_ascii=False, indent=2),
                "```",
                "",
            ])
    options.output.with_suffix(".md").write_text("\n".join(lines), encoding="utf-8")
    print(
        "Diagnóstico GUID v2: "
        f"{len(path_conflicts)} rutas, {len(guid_conflicts)} GUID, "
        f"{len(outfit_guid_conflicts)} outfits y "
        f"{len(duplicate_names_same_gender)} duplicados de nombre por género"
    )


if __name__ == "__main__":
    main()
