#!/usr/bin/env python3
"""Retira de ECZ2_Ajustes solo modelos idénticos ya suministrados por ECZ2_18."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = next(ROOT.glob('*/Contents/mods/ECZ2_18/42/media'))
TARGET = next(ROOT.glob('*/Contents/mods/ECZ2_Ajustes/42.18/media'))
REPORT = Path(__file__).with_name('MODELOS_DUPLICADOS_ELIMINADOS.json')


def digest(path: Path) -> str:
    h = hashlib.sha256()
    with path.open('rb') as fh:
        for block in iter(lambda: fh.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def is_model(relative: Path) -> bool:
    low = relative.as_posix().lower()
    return '/models/' in '/' + low or relative.suffix.lower() in {'.fbx', '.x', '.xmodel', '.mesh'}


def main() -> int:
    source_files = {}
    for path in SOURCE.rglob('*'):
        if path.is_file():
            relative = path.relative_to(SOURCE)
            if is_model(relative):
                source_files[relative.as_posix().lower()] = path

    removed = []
    skipped = []
    for target in sorted(TARGET.rglob('*')):
        if not target.is_file():
            continue
        relative = target.relative_to(TARGET)
        if not is_model(relative):
            continue
        source = source_files.get(relative.as_posix().lower())
        if source is None:
            skipped.append({'path': relative.as_posix(), 'reason': 'sin equivalente en ECZ2_18'})
            continue
        source_sha = digest(source)
        target_sha = digest(target)
        if source_sha != target_sha:
            skipped.append({'path': relative.as_posix(), 'reason': 'hash diferente', 'source_sha': source_sha, 'target_sha': target_sha})
            continue
        removed.append({'path': relative.as_posix(), 'sha256': source_sha, 'bytes': target.stat().st_size})
        target.unlink()

    for directory in sorted((p for p in TARGET.rglob('*') if p.is_dir()), key=lambda p: len(p.parts), reverse=True):
        try:
            directory.rmdir()
        except OSError:
            pass

    result = {
        'source': str(SOURCE.relative_to(ROOT)).replace('\\', '/'),
        'target': str(TARGET.relative_to(ROOT)).replace('\\', '/'),
        'removed_files': len(removed),
        'removed_bytes': sum(item['bytes'] for item in removed),
        'skipped_files': len(skipped),
        'removed': removed,
        'skipped': skipped,
        'safety': 'Solo se elimina cuando ruta virtual y SHA-256 coinciden exactamente con ECZ2_18.'
    }
    REPORT.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({k: result[k] for k in ('removed_files', 'removed_bytes', 'skipped_files')}, ensure_ascii=False))
    if skipped:
        return 1
    if len(removed) != 402 or result['removed_bytes'] != 230671000:
        print('La cantidad eliminada no coincide con la auditoría previa.')
        return 1
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
