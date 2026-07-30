#!/usr/bin/env python3
"""Audit translation-key coverage and technical-token integrity for EclipseZ."""

from __future__ import annotations

import argparse
import ast
import json
import re
from collections import Counter, defaultdict
from pathlib import Path
from typing import Iterable


TECH_TOKEN = re.compile(
    r"</?[A-Z][A-Z0-9_]*(?::[^<>]*)?>"
    r"|</?(?:br|font|b|i|u)(?:\s+[^<>]*)?>"
    r"|\[img=[^\]]+\]"
    r"|%(?:\d+\$)?[A-Za-z]"
    r"|%\d+"
)
TXT_ENTRY = re.compile(
    r'^\s*([A-Za-z0-9_."-]+)\s*=\s*("(?:\\.|[^"\\])*")\s*,?\s*(?:--.*)?$'
)


def read_json(path: Path) -> dict[str, str]:
    with path.open("r", encoding="utf-8-sig") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError(f"{path}: JSON root is not an object")
    return {str(key): str(value) for key, value in data.items()}


def read_txt(path: Path) -> tuple[dict[str, str], int]:
    result: dict[str, str] = {}
    unparsed = 0
    text = path.read_text(encoding="utf-8-sig", errors="replace")
    for line in text.splitlines():
        match = TXT_ENTRY.match(line)
        if match:
            key, literal = match.groups()
            try:
                result[key] = ast.literal_eval(literal)
            except (SyntaxError, ValueError):
                unparsed += 1
        elif "=" in line and not line.lstrip().startswith(("--", "#", "//")):
            unparsed += 1
    return result, unparsed


def version_tuple(name: str) -> tuple[int, ...] | None:
    if not re.fullmatch(r"\d+(?:\.\d+)*", name):
        return None
    return tuple(int(part) for part in name.split("."))


def active_version_folders(repo: Path) -> dict[Path, str | None]:
    selected: dict[Path, str | None] = {}
    for mods_folder in repo.rglob("mods"):
        if not mods_folder.is_dir() or mods_folder.parent.name != "Contents":
            continue
        for mod_root in (path for path in mods_folder.iterdir() if path.is_dir()):
            compatible: list[tuple[tuple[int, ...], str]] = []
            for child in (path for path in mod_root.iterdir() if path.is_dir()):
                parsed = version_tuple(child.name)
                if parsed is not None and parsed <= (42, 20, 0):
                    compatible.append((parsed, child.name))
            selected[mod_root.resolve()] = max(compatible)[1] if compatible else None
    return selected


def is_active_translation(path: Path, selected: dict[Path, str | None]) -> bool:
    parts = path.parts
    lowered = [part.casefold() for part in parts]
    try:
        mods_index = len(parts) - 1 - lowered[::-1].index("mods")
    except ValueError:
        return True
    if mods_index + 2 >= len(parts):
        return False
    mod_root = Path(*parts[: mods_index + 2]).resolve()
    layer = parts[mods_index + 2]
    chosen_version = selected.get(mod_root)
    if layer.casefold() == "common":
        return True
    if version_tuple(layer) is not None:
        return layer == chosen_version
    # Legacy root media is considered only when the mod has no B42 version layer.
    return chosen_version is None and layer.casefold() == "media"


def translation_files(
    repo: Path,
    language: str,
    selected: dict[Path, str | None],
) -> Iterable[Path]:
    wanted = language.casefold()
    for path in repo.rglob("*"):
        if not path.is_file() or path.suffix.casefold() not in {".json", ".txt"}:
            continue
        parts = [part.casefold() for part in path.parts]
        if "translate" not in parts:
            continue
        translate_index = len(parts) - 1 - parts[::-1].index("translate")
        if (
            translate_index + 1 < len(parts)
            and parts[translate_index + 1] == wanted
            and is_active_translation(path, selected)
        ):
            yield path


def read_translation_file(path: Path) -> tuple[dict[str, str], int]:
    if path.suffix.casefold() == ".json":
        return read_json(path), 0
    return read_txt(path)


def category_name(path: Path) -> str:
    return re.sub(r"_(?:EN|ES)$", "", path.stem, flags=re.IGNORECASE).casefold()


def translation_scope(path: Path, category: str) -> str:
    if category != "mod":
        return ""
    lowered = [part.casefold() for part in path.parts]
    try:
        index = len(lowered) - 1 - lowered[::-1].index("mods")
    except ValueError:
        return ""
    return path.parts[index + 1].casefold() if index + 1 < len(path.parts) else ""


def token_counter(value: str) -> Counter[str]:
    return Counter(TECH_TOKEN.findall(value))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    repo = args.repo.resolve()
    selected = active_version_folders(repo)

    english: dict[tuple[str, str, str], list[tuple[str, str]]] = defaultdict(list)
    spanish_local: dict[tuple[str, str, str], list[tuple[str, str]]] = defaultdict(list)
    unparsed: list[dict[str, int | str]] = []

    for language, destination in (("EN", english), ("ES", spanish_local)):
        for path in translation_files(repo, language, selected):
            entries, bad_lines = read_translation_file(path)
            relative = path.relative_to(repo).as_posix()
            category = category_name(path)
            scope = translation_scope(path, category)
            for key, value in entries.items():
                destination[(category, scope, key)].append((relative, value))
            if bad_lines:
                unparsed.append({"file": relative, "lines": bad_lines})

    central_folder = (
        repo
        / "ECZTraducciones/Contents/mods/ECZ_Mods/42.20.0/media/lua/shared/Translate/ES"
    )
    central: dict[tuple[str, str, str], tuple[str, str]] = {}
    for path in sorted(central_folder.glob("*.json"), key=lambda item: item.name.casefold()):
        category = category_name(path)
        scope = translation_scope(path, category)
        for key, value in read_json(path).items():
            central[(category, scope, key)] = (path.relative_to(repo).as_posix(), value)

    missing: list[dict[str, object]] = []
    token_mismatches: list[dict[str, object]] = []
    identical: list[dict[str, object]] = []
    conflicting_english: list[dict[str, object]] = []

    for (category, scope, key), sources in sorted(english.items()):
        distinct_source_values = list(dict.fromkeys(value for _path, value in sources))
        if len(distinct_source_values) > 1:
            conflicting_english.append(
                {
                    "key": key,
                    "category": category,
                    "scope": scope,
                    "values": distinct_source_values,
                    "files": [path for path, _value in sources],
                }
            )

        identity = (category, scope, key)
        selected_spanish = central.get(identity)
        if selected_spanish is None and not scope:
            selected_spanish = central.get((category, "", key))
        if selected_spanish is None and identity in spanish_local:
            selected_spanish = spanish_local[identity][-1]
        if selected_spanish is None:
            missing.append(
                {
                    "key": key,
                    "category": category,
                    "scope": scope,
                    "english": distinct_source_values[0],
                    "files": [path for path, _value in sources],
                }
            )
            continue

        spanish_path, spanish_value = selected_spanish
        source_value = distinct_source_values[0]
        if token_counter(source_value) != token_counter(spanish_value):
            token_mismatches.append(
                {
                    "key": key,
                    "category": category,
                    "scope": scope,
                    "english": source_value,
                    "spanish": spanish_value,
                    "english_files": [path for path, _value in sources],
                    "spanish_file": spanish_path,
                    "english_tokens": list(TECH_TOKEN.findall(source_value)),
                    "spanish_tokens": list(TECH_TOKEN.findall(spanish_value)),
                }
            )
        if source_value == spanish_value and re.search(r"[A-Za-z]{3}", source_value):
            identical.append(
                {
                    "key": key,
                    "category": category,
                    "scope": scope,
                    "value": source_value,
                    "english_files": [path for path, _value in sources],
                    "spanish_file": spanish_path,
                }
            )

    report = {
        "scope": "common plus highest compatible version layer for Build 42.20.0",
        "english_files": len(list(translation_files(repo, "EN", selected))),
        "spanish_files": len(list(translation_files(repo, "ES", selected))),
        "english_keys": len(english),
        "spanish_keys_local_or_central": len(set(spanish_local) | set(central)),
        "central_keys": len(central),
        "missing_keys": missing,
        "technical_token_mismatches": token_mismatches,
        "identical_english_spanish": identical,
        "conflicting_english_sources": conflicting_english,
        "unparsed_legacy_lines": unparsed,
    }
    output = repo / "docs/mod-localization-audit.json"
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    print(
        json.dumps(
            {
                "english_files": report["english_files"],
                "spanish_files": report["spanish_files"],
                "english_keys": report["english_keys"],
                "central_keys": report["central_keys"],
                "missing_keys": len(missing),
                "technical_token_mismatches": len(token_mismatches),
                "identical_english_spanish": len(identical),
                "conflicting_english_sources": len(conflicting_english),
                "unparsed_legacy_files": len(unparsed),
            },
            ensure_ascii=False,
            indent=2,
        )
    )
    print(f"Report: {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
