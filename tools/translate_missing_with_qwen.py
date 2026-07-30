#!/usr/bin/env python3
"""Translate currently missing active mod keys with the user's local Qwen."""

from __future__ import annotations

import argparse
import json
import re
import time
import urllib.error
import urllib.request
from collections import defaultdict
from pathlib import Path
from typing import Any

from build_localization_42_20 import align_tokens, read_json, write_json


def destination_name(source_files: list[str]) -> str:
    stem = Path(source_files[0]).stem
    return re.sub(r"_EN$", "", stem, flags=re.IGNORECASE) + ".json"


def request_qwen(
    endpoint: str,
    model: str,
    system_prompt: str,
    entries: dict[str, str],
    feedback: str = "",
) -> dict[str, str]:
    user_prompt = (
        "Traduce al español de España los valores del siguiente objeto JSON. "
        "Las claves son identificadores inmutables. Devuelve ÚNICAMENTE un objeto JSON válido "
        "con exactamente las mismas claves, en el mismo orden, y valores de tipo cadena. "
        "Conserva literalmente todas las variables (%1, %2, %s...), etiquetas (<LINE>, <RGB:...>, "
        "<SPACE>, <br>...), rutas, identificadores y marcas técnicas. No resumas ni omitas contenido."
    )
    if feedback:
        user_prompt += "\nCorrige además estos problemas detectados en el intento anterior:\n" + feedback
    user_prompt += "\n\nENTRADAS:\n" + json.dumps(entries, ensure_ascii=False, indent=2)
    payload = {
        "model": model,
        "stream": False,
        "think": False,
        "format": "json",
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt},
        ],
        "options": {
            "temperature": 0.1,
            "seed": 42,
            "num_ctx": 32768,
            "num_predict": 4096,
        },
    }
    request = urllib.request.Request(
        endpoint.rstrip("/") + "/api/chat",
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=900) as response:
        result = json.loads(response.read().decode("utf-8"))
    content = result["message"]["content"].strip()
    parsed = json.loads(content)
    if not isinstance(parsed, dict):
        raise ValueError("Qwen did not return a JSON object")
    return {str(key): str(value) for key, value in parsed.items()}


def make_batches(entries: list[dict[str, Any]], max_entries: int, max_chars: int) -> list[list[dict[str, Any]]]:
    batches: list[list[dict[str, Any]]] = []
    current: list[dict[str, Any]] = []
    chars = 0
    for entry in entries:
        cost = len(entry["key"]) + len(entry["english"]) + 16
        if current and (len(current) >= max_entries or chars + cost > max_chars):
            batches.append(current)
            current = []
            chars = 0
        current.append(entry)
        chars += cost
    if current:
        batches.append(current)
    return batches


def validate_batch(
    source: dict[str, str],
    translated: dict[str, str],
) -> tuple[dict[str, str], list[str]]:
    accepted: dict[str, str] = {}
    errors: list[str] = []
    if list(translated) != list(source):
        missing = [key for key in source if key not in translated]
        extra = [key for key in translated if key not in source]
        if missing:
            errors.append("Faltan claves: " + ", ".join(missing))
        if extra:
            errors.append("Sobran claves: " + ", ".join(extra))
    for key, source_value in source.items():
        if key not in translated:
            continue
        candidate = translated[key].strip()
        aligned, ok = align_tokens(source_value, candidate)
        if not ok:
            errors.append(f"{key}: no conserva la cantidad de marcas técnicas")
            continue
        if source_value and not aligned:
            errors.append(f"{key}: traducción vacía")
            continue
        accepted[key] = aligned
    return accepted, errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--prompt", type=Path, required=True)
    parser.add_argument("--endpoint", default="http://127.0.0.1:11434")
    parser.add_argument("--model", default="qwen3.5:latest")
    parser.add_argument("--max-entries", type=int, default=50)
    parser.add_argument("--max-chars", type=int, default=6000)
    parser.add_argument("--limit-batches", type=int)
    parser.add_argument("--entries-json", type=Path)
    parser.add_argument("--progress-name", default="qwen-42.20-category-translations.json")
    args = parser.parse_args()

    repo = args.repo.resolve()
    system_prompt = args.prompt.read_text(encoding="utf-8-sig")
    if args.entries_json:
        missing = json.loads(args.entries_json.resolve().read_text(encoding="utf-8"))
    else:
        audit = json.loads((repo / "docs/mod-localization-audit.json").read_text(encoding="utf-8"))
        missing = audit["missing_keys"]
    batches = make_batches(missing, args.max_entries, args.max_chars)
    if args.limit_batches is not None:
        batches = batches[: args.limit_batches]
    progress_path = repo / "docs" / args.progress_name
    progress: dict[str, dict[str, str]] = {}
    if progress_path.exists():
        progress = json.loads(progress_path.read_text(encoding="utf-8"))

    failures: list[dict[str, Any]] = []
    started = time.monotonic()
    for index, batch in enumerate(batches, start=1):
        pending = {
            f"{entry['category']}::{entry['key']}": entry["english"]
            for entry in batch
            if f"{entry['category']}::{entry['key']}" not in progress
        }
        if not pending:
            print(f"[{index}/{len(batches)}] ya completado", flush=True)
            continue

        accepted: dict[str, str] = {}
        feedback = ""
        for attempt in range(1, 4):
            try:
                translated = request_qwen(
                    args.endpoint,
                    args.model,
                    system_prompt,
                    pending,
                    feedback,
                )
                accepted_now, errors = validate_batch(pending, translated)
                accepted.update(accepted_now)
                pending = {key: value for key, value in pending.items() if key not in accepted_now}
                if not pending:
                    break
                feedback = "\n".join(errors[:30])
            except (OSError, urllib.error.URLError, ValueError, KeyError, json.JSONDecodeError) as error:
                feedback = str(error)
            print(
                f"[{index}/{len(batches)}] intento {attempt}: quedan {len(pending)}",
                flush=True,
            )

        for entry in batch:
            key = entry["key"]
            identity = f"{entry['category']}::{key}"
            if identity in accepted:
                target = destination_name(entry["files"])
                progress[identity] = {
                    "category": entry["category"],
                    "key": key,
                    "file": target,
                    "value": accepted[identity],
                }
            elif identity not in progress:
                failures.append(entry)
        progress_path.write_text(
            json.dumps(progress, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
            newline="\n",
        )
        elapsed = time.monotonic() - started
        print(
            f"[{index}/{len(batches)}] guardadas {len(progress)}; "
            f"fallos acumulados {len(failures)}; {elapsed:.1f}s",
            flush=True,
        )

    central_folder = (
        repo
        / "ECZTraducciones/Contents/mods/ECZ_Mods/42.20.0/media/lua/shared/Translate/ES"
    )
    grouped: dict[str, dict[str, str]] = defaultdict(dict)
    for _identity, item in progress.items():
        grouped[item["file"]][item["key"]] = item["value"]
    for filename, additions in grouped.items():
        path = central_folder / filename
        data = read_json(path) if path.exists() else {}
        data.update(additions)
        write_json(path, data)

    report = {
        "model": args.model,
        "translated": len(progress),
        "failed": len(failures),
        "failed_entries": failures,
        "seconds": round(time.monotonic() - started, 1),
    }
    report_path = repo / "docs/qwen-42.20-translation-report.json"
    report_path.write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    print(json.dumps(report | {"failed_entries": f"{len(failures)} entries"}, ensure_ascii=False, indent=2))
    return 0 if not failures else 2


if __name__ == "__main__":
    raise SystemExit(main())
