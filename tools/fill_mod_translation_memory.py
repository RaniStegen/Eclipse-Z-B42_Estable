#!/usr/bin/env python3
"""Fill active missing mod keys from EclipseZ's historical translation memory."""

from __future__ import annotations

import argparse
import json
import re
from collections import Counter, defaultdict
from pathlib import Path

from audit_mod_localization import TECH_TOKEN, read_translation_file
from build_localization_42_20 import align_tokens, read_json, repair_mojibake, write_json


def all_translation_files(repo: Path, language: str) -> list[Path]:
    result: list[Path] = []
    wanted = language.casefold()
    for path in repo.rglob("*"):
        if not path.is_file() or path.suffix.casefold() not in {".json", ".txt"}:
            continue
        lowered = [part.casefold() for part in path.parts]
        if "translate" not in lowered:
            continue
        index = len(lowered) - 1 - lowered[::-1].index("translate")
        if index + 1 < len(lowered) and lowered[index + 1] == wanted:
            result.append(path)
    return result


def destination_name(source_files: list[str]) -> str:
    preferred = Path(source_files[0]).name
    stem = Path(preferred).stem
    stem = re.sub(r"_EN$", "", stem, flags=re.IGNORECASE)
    return stem + ".json"


def compatible(source: str, candidate: str) -> tuple[str, bool]:
    repaired = repair_mojibake(candidate)
    return align_tokens(source, repaired)


def pick_candidate(source: str, candidates: Counter[str], *, require_unique: bool = False) -> str | None:
    ranked: list[tuple[int, int, str]] = []
    for candidate, frequency in candidates.items():
        aligned, ok = compatible(source, candidate)
        if ok and aligned:
            ranked.append((frequency, len(aligned), aligned))
    if not ranked:
        return None
    if require_unique and len({candidate for _frequency, _length, candidate in ranked}) != 1:
        return None
    ranked.sort(reverse=True)
    return ranked[0][2]


def normalize_key(key: str) -> str:
    return re.sub(r"[^a-z0-9]", "", key.casefold())


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()
    repo = args.repo.resolve()
    audit_path = repo / "docs/mod-localization-audit.json"
    audit = json.loads(audit_path.read_text(encoding="utf-8"))

    english_by_key: dict[str, Counter[str]] = defaultdict(Counter)
    spanish_by_key: dict[str, Counter[str]] = defaultdict(Counter)
    for language, destination in (("EN", english_by_key), ("ES", spanish_by_key)):
        for path in all_translation_files(repo, language):
            entries, _bad_lines = read_translation_file(path)
            for key, value in entries.items():
                destination[key][value] += 1

    central_folder = (
        repo
        / "ECZTraducciones/Contents/mods/ECZ_Mods/42.20.0/media/lua/shared/Translate/ES"
    )
    central_files: dict[str, dict[str, str]] = {}
    for path in central_folder.glob("*.json"):
        central_files[path.name] = read_json(path)
        for key, value in central_files[path.name].items():
            spanish_by_key[key][value] += 5

    spanish_by_normalized_key: dict[str, Counter[str]] = defaultdict(Counter)
    for key, values in spanish_by_key.items():
        spanish_by_normalized_key[normalize_key(key)].update(values)

    memory: dict[str, Counter[str]] = defaultdict(Counter)
    for key in english_by_key.keys() & spanish_by_key.keys():
        if key in {"description", "name", "title"}:
            continue
        for english, english_frequency in english_by_key[key].items():
            for spanish, spanish_frequency in spanish_by_key[key].items():
                aligned, ok = compatible(english, spanish)
                if ok and aligned:
                    memory[english][aligned] += english_frequency * spanish_frequency

    suggestions: list[dict[str, str]] = []
    unresolved: list[dict[str, object]] = []
    method_counts: Counter[str] = Counter()
    for item in audit["missing_keys"]:
        key = item["key"]
        source = item["english"]
        candidate = pick_candidate(source, spanish_by_key.get(key, Counter()))
        method = "same-key-history"
        if candidate is None:
            candidate = pick_candidate(
                source,
                spanish_by_normalized_key.get(normalize_key(key), Counter()),
                require_unique=True,
            )
            method = "normalized-key-history"
        if candidate is None:
            candidate = pick_candidate(source, memory.get(source, Counter()), require_unique=True)
            method = "exact-text-memory"
        if candidate is None:
            unresolved.append(item)
            continue
        target_name = destination_name(item["files"])
        suggestions.append(
            {
                "file": target_name,
                "key": key,
                "english": source,
                "spanish": candidate,
                "method": method,
            }
        )
        method_counts[method] += 1

    if args.apply:
        for suggestion in suggestions:
            filename = suggestion["file"]
            if filename not in central_files:
                central_files[filename] = {}
            central_files[filename][suggestion["key"]] = suggestion["spanish"]
        for filename, entries in central_files.items():
            write_json(central_folder / filename, entries)

    report = {
        "applied": args.apply,
        "suggestions": len(suggestions),
        "unresolved": len(unresolved),
        "methods": dict(sorted(method_counts.items())),
        "entries": suggestions,
        "unresolved_entries": unresolved,
    }
    output = repo / "docs/mod-translation-memory-report.json"
    output.write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    print(
        json.dumps(
            {
                "applied": args.apply,
                "suggestions": len(suggestions),
                "unresolved": len(unresolved),
                "methods": dict(sorted(method_counts.items())),
            },
            ensure_ascii=False,
            indent=2,
        )
    )
    print(f"Report: {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
