#!/usr/bin/env python3
"""Find likely English prose left unchanged in the active Spanish localization."""

from __future__ import annotations

import json
import re
from pathlib import Path


ENGLISH_PROSE = re.compile(
    r"\b(?:the|and|or|with|without|from|for|of|in|on|is|are|was|were|can|cannot|"
    r"you|your|this|that|these|those|needs?|current|failed|warning|danger|after|"
    r"before|while|only|used|make|keep|fresh|every|little|smile|box|gateway|key|"
    r"tears|please|waste|good|suffering|said|would|bring|crowd|mention|screams|"
    r"combine|alcohol|jar|lid|homemade|vinegar|blood|player|donation|volume|"
    r"compatible|contaminated|dispose|safely|tracked|resetting|monitor|state|"
    r"restores|fluid|type|read|reach|level|assess|high|saline|risk|oxygen|"
    r"building|umbrella|shades|hat|cap|mask|shorts|fermenting|press)\b",
    re.IGNORECASE,
)
SKIP_CATEGORIES = {"contextmenu", "moveables", "print_media", "recorded_media"}
TECHNICAL_FRAGMENT = re.compile(r"\.\.|tostring\(|\bdef\.|\bdef and\b|^\s*[%)]")


def main() -> int:
    repo = Path(__file__).resolve().parents[1]
    audit_path = repo / "docs/mod-localization-audit.json"
    audit = json.loads(audit_path.read_text(encoding="utf-8"))
    candidates: list[dict[str, object]] = []
    for item in audit["identical_english_spanish"]:
        value = item["value"]
        if item["category"] in SKIP_CATEGORIES:
            continue
        if value in {"zDoNotPickMe", "Neat Building"} or TECHNICAL_FRAGMENT.search(value):
            continue
        if not ENGLISH_PROSE.search(value):
            continue
        candidates.append(
            {
                "category": item["category"],
                "scope": item.get("scope", ""),
                "key": item["key"],
                "english": value,
                "files": item["english_files"],
            }
        )
    output = repo / "docs/untranslated-candidates.json"
    output.write_text(
        json.dumps(candidates, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    print(json.dumps({"candidates": len(candidates)}, indent=2))
    print(f"Report: {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
