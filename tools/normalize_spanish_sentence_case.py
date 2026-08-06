#!/usr/bin/env python3
"""Normalize Spanish UI text without lowercasing proper names or technical tokens."""

from __future__ import annotations

import json
import re
from collections import Counter
from pathlib import Path

from build_localization_42_20 import read_json, write_json


WORD = re.compile(r"(?u)\b[^\W\d_][\wÀ-ÿ-]*\b")
BOUNDARY = re.compile(r"(?:[.!?¿¡:;\n|]|<LINE>|<br\s*/?>|\s[-–—]\s)", re.IGNORECASE)
FUNCTION_WORDS = {
    "a", "al", "ante", "bajo", "con", "contra", "de", "del", "desde",
    "durante", "e", "el", "en", "entre", "hacia", "hasta", "la", "las",
    "lo", "los", "o", "para", "por", "según", "sin", "sobre", "tras", "u",
    "un", "una", "unos", "unas", "y",
}
PROPER_WORDS = {
    "Blackwood", "Cathaya", "Colt", "Discord", "Eclipse", "Gunworks",
    "Hot", "Kentucky", "Knox", "Marz", "Muldraugh", "Project", "Rosewood",
    "Steam", "Workshop", "Zomboid",
}
PROPER_PHRASES = {"Selva Negra"}
EXCLUDED_FILES = {
    "ContextMenu.json",
    "DynamicRadio.json",
    "Print_Media.json",
    "Recorded_Media.json",
}


def inside_tag(text: str, position: int) -> bool:
    return text.rfind("<", 0, position) > text.rfind(">", 0, position)


def spanish_dictionary() -> object | None:
    try:
        from spellchecker import SpellChecker
    except ImportError:
        return None
    return SpellChecker(language="es")


def is_spanish_common_word(token: str, dictionary: object | None) -> bool:
    if dictionary is None:
        return False
    word = token.casefold()
    variants = {word}
    if word.endswith("es") and len(word) > 4:
        variants.add(word[:-2])
    if word.endswith("s") and len(word) > 3:
        variants.add(word[:-1])
    for variant in tuple(variants):
        if variant.endswith("a"):
            variants.add(variant[:-1] + "o")
        elif variant.endswith("o"):
            variants.add(variant[:-1] + "a")
    return any(variant in dictionary for variant in variants)


def normalize_value(
    value: str,
    lowercase_vocabulary: Counter[str],
    dictionary: object | None,
) -> tuple[str, int]:
    matches = list(WORD.finditer(value))
    if len(matches) < 2:
        return value, 0

    replacements: list[tuple[int, int, str]] = []
    protected_ranges = [
        match.span()
        for phrase in PROPER_PHRASES
        for match in re.finditer(re.escape(phrase), value)
    ]
    previous_end = 0
    at_segment_start = True
    for match in matches:
        token = match.group()
        if inside_tag(value, match.start()):
            continue

        separator = value[previous_end:match.start()]
        if BOUNDARY.search(separator):
            at_segment_start = True

        is_title_word = (
            len(token) > 1
            and token[0].isupper()
            and token[1:].islower()
            and token not in PROPER_WORDS
            and not any(start <= match.start() < end for start, end in protected_ranges)
        )
        folded = token.casefold()
        is_known_common = lowercase_vocabulary[folded] >= 2
        if not at_segment_start and is_title_word and (
            folded in FUNCTION_WORDS
            or is_known_common
            or is_spanish_common_word(token, dictionary)
        ):
            replacements.append((match.start(), match.end(), token.lower()))

        at_segment_start = False
        previous_end = match.end()

    if not replacements:
        return value, 0
    output = value
    for start, end, replacement in reversed(replacements):
        output = output[:start] + replacement + output[end:]
    return output, len(replacements)


def main() -> int:
    repo = Path(__file__).resolve().parents[1]
    folder = (
        repo
        / "ECZTraducciones/Contents/mods/ECZ_Mods/42.20.0/media/lua/shared/Translate/ES"
    )

    documents = {
        path: read_json(path)
        for path in sorted(folder.glob("*.json"))
        if path.name not in EXCLUDED_FILES
    }
    lowercase_vocabulary: Counter[str] = Counter()
    dictionary = spanish_dictionary()
    for data in documents.values():
        for value in data.values():
            for match in WORD.finditer(value):
                token = match.group()
                if len(token) > 1 and token == token.lower():
                    lowercase_vocabulary[token.casefold()] += 1

    changed_values = 0
    changed_words = 0
    by_file: Counter[str] = Counter()
    samples: list[dict[str, str]] = []
    for path, data in documents.items():
        changed = False
        for key, value in data.items():
            normalized, count = normalize_value(value, lowercase_vocabulary, dictionary)
            if not count:
                continue
            data[key] = normalized
            changed = True
            changed_values += 1
            changed_words += count
            by_file[path.name] += 1
            if len(samples) < 60:
                samples.append(
                    {"file": path.name, "key": key, "before": value, "after": normalized}
                )
        if changed:
            write_json(path, data)

    report = {
        "policy": "Spanish sentence case; proper names and technical tokens preserved",
        "spanish_dictionary_used": dictionary is not None,
        "changed_values": changed_values,
        "changed_words": changed_words,
        "by_file": dict(by_file.most_common()),
        "samples": samples,
    }
    (repo / "docs/spanish-sentence-case-report.json").write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    print(json.dumps({key: value for key, value in report.items() if key != "samples"},
                     ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
