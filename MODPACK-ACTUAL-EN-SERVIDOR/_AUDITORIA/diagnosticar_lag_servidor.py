#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from collections import Counter, defaultdict
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Iterable

TEXT_EXT = {'.lua', '.txt', '.xml', '.json', '.ini', '.cfg', '.properties', '.md'}
VERSION_RE = re.compile(r'^\d+(?:\.\d+)*$')
EVENT_WEIGHTS = {
    'OnTick': 35,
    'OnPlayerUpdate': 20,
    'OnZombieUpdate': 35,
    'OnObjectAdded': 12,
    'OnObjectAboutToBeRemoved': 8,
    'OnLoadGridSquare': 18,
    'LoadGridsquare': 18,
    'EveryOneMinute': 8,
    'EveryTenMinutes': 3,
    'EveryHours': 2,
    'OnFillWorldObjectContextMenu': 1,
    'OnClientCommand': 8,
    'OnServerCommand': 8,
    'OnPlayerMove': 25,
    'OnVehicleDamageTexture': 4,
    'OnEnterVehicle': 8,
    'OnExitVehicle': 8,
}
PATTERNS = {
    'zone_map': re.compile(r'ZONE_MAP', re.I),
    'move_zombie': re.compile(r'moveZombie|nz\.zombies', re.I),
    'tier_zombies': re.compile(r'zombie.{0,20}tier|tier.{0,20}zombie|zone.{0,20}tier|tier.{0,20}zone', re.I),
    'inventorymale': re.compile(r'inventorymale|inventoryfemale', re.I),
    'turning180': re.compile(r'turning180', re.I),
    'spriteconfig': re.compile(r'SpriteConfig', re.I),
    'vehicle_runtime': re.compile(r'getVehicle\(|IsoVehicle|VehicleManager|VehicleRequest|OnEnterVehicle|OnExitVehicle', re.I),
    'network_runtime': re.compile(r'sendClientCommand|sendServerCommand|transmit|UdpConnection|sendObjectChange', re.I),
    'zombie_iteration': re.compile(r'getCell\(\):getZombieList|getZombieList\(|getZombies\(|for\s+\w+\s*=\s*0\s*,\s*[^\n]*zombie', re.I),
    'player_iteration': re.compile(r'getOnlinePlayers\(|getPlayers\(|getPlayer\(', re.I),
}
LOG_OBJECTS = [
    'Wooden_Windows', 'Commercial_GridGlassBlackWall', 'DoubleWireGate',
    'SandFloor', 'GravelFloor', 'WoodFloorLvl2', 'WoodFloorLvl3'
]

@dataclass
class Hit:
    mod: str
    path: str
    line: int
    text: str


def read_text(path: Path) -> str:
    raw = path.read_bytes()
    for enc in ('utf-8-sig', 'utf-8', 'utf-16', 'cp1252'):
        try:
            return raw.decode(enc)
        except UnicodeError:
            pass
    return raw.decode('utf-8', errors='replace')


def parse_mod_id(mod_root: Path) -> str:
    ids = []
    for info in mod_root.rglob('mod.info'):
        if 'media' in {p.lower() for p in info.relative_to(mod_root).parts}:
            continue
        for line in read_text(info).splitlines():
            if line.strip().lower().startswith('id='):
                ids.append(line.split('=', 1)[1].strip())
    return Counter(ids).most_common(1)[0][0] if ids else mod_root.name


def discover(root: Path) -> dict[Path, str]:
    out = {}
    for mods_dir in root.glob('*/Contents/mods'):
        if not mods_dir.is_dir():
            continue
        for mod_root in mods_dir.iterdir():
            if mod_root.is_dir():
                out[mod_root] = parse_mod_id(mod_root)
    return out


def iter_files(mod_root: Path) -> Iterable[Path]:
    for path in mod_root.rglob('*'):
        if path.is_file():
            yield path


def relative(path: Path, root: Path) -> str:
    try:
        return path.relative_to(root).as_posix()
    except ValueError:
        return path.as_posix()


def scan(root: Path) -> tuple[dict, list[Hit]]:
    mods = discover(root)
    stats = {}
    all_hits: list[Hit] = []
    exact_hits: dict[str, list[dict]] = defaultdict(list)

    for mod_root, mod_id in sorted(mods.items(), key=lambda kv: kv[1].lower()):
        s = {
            'id': mod_id,
            'root': relative(mod_root, root),
            'files': 0,
            'bytes': 0,
            'lua_files': 0,
            'lua_lines': 0,
            'server_lua_files': 0,
            'server_lua_lines': 0,
            'shared_lua_files': 0,
            'client_lua_files': 0,
            'map_bytes': 0,
            'texture_bytes': 0,
            'model_bytes': 0,
            'sound_bytes': 0,
            'vehicle_script_files': 0,
            'map_files': 0,
            'event_hooks': Counter(),
            'pattern_counts': Counter(),
            'core_overrides': [],
            'hot_files': [],
        }
        for path in iter_files(mod_root):
            s['files'] += 1
            try:
                size = path.stat().st_size
            except OSError:
                size = 0
            s['bytes'] += size
            low = path.as_posix().lower()
            ext = path.suffix.lower()
            if any(token in low for token in ('/media/maps/', '/media/map/')) or ext in {'.lotpack', '.lotheader', '.bin'}:
                s['map_bytes'] += size
                s['map_files'] += 1
            if ext in {'.png', '.dds', '.jpg', '.jpeg'}:
                s['texture_bytes'] += size
            if ext in {'.fbx', '.x', '.xmodel', '.mesh'} or '/models/' in low:
                s['model_bytes'] += size
            if ext in {'.ogg', '.wav', '.mp3'}:
                s['sound_bytes'] += size
            if '/scripts/vehicles/' in low or '/vehicles/' in low and ext == '.txt':
                s['vehicle_script_files'] += 1
            if ext not in TEXT_EXT:
                continue
            try:
                text = read_text(path)
            except OSError:
                continue
            lines = text.splitlines()
            if ext == '.lua':
                s['lua_files'] += 1
                s['lua_lines'] += len(lines)
                if '/media/lua/server/' in low:
                    s['server_lua_files'] += 1
                    s['server_lua_lines'] += len(lines)
                elif '/media/lua/shared/' in low:
                    s['shared_lua_files'] += 1
                elif '/media/lua/client/' in low:
                    s['client_lua_files'] += 1
                if re.search(r'/media/lua/(?:client|server|shared)/(?:isui|network|vehicles|zombie|chat)/', low):
                    s['core_overrides'].append(relative(path, root))
                for event, weight in EVENT_WEIGHTS.items():
                    count = len(re.findall(rf'Events\.{re.escape(event)}\.Add\s*\(', text))
                    if count:
                        s['event_hooks'][event] += count
            file_score = 0
            file_reasons = Counter()
            for name, rx in PATTERNS.items():
                matches = list(rx.finditer(text))
                if matches:
                    s['pattern_counts'][name] += len(matches)
                    file_reasons[name] += len(matches)
                    file_score += len(matches)
                    for m in matches[:20]:
                        line_no = text.count('\n', 0, m.start()) + 1
                        snippet = lines[line_no - 1].strip()[:300] if lines else ''
                        all_hits.append(Hit(mod_id, relative(path, root), line_no, snippet))
            for obj in LOG_OBJECTS:
                for idx, line in enumerate(lines, 1):
                    if obj.lower() in line.lower():
                        exact_hits[obj].append({'mod': mod_id, 'path': relative(path, root), 'line': idx, 'text': line.strip()[:300]})
            if file_score:
                s['hot_files'].append({'path': relative(path, root), 'score': file_score, 'reasons': dict(file_reasons)})

        event_score = sum(EVENT_WEIGHTS.get(k, 1) * v for k, v in s['event_hooks'].items())
        runtime_score = (
            event_score
            + s['pattern_counts']['zombie_iteration'] * 18
            + s['pattern_counts']['move_zombie'] * 20
            + s['pattern_counts']['zone_map'] * 15
            + s['pattern_counts']['tier_zombies'] * 8
            + s['pattern_counts']['vehicle_runtime'] * 3
            + s['pattern_counts']['network_runtime'] * 4
            + min(s['server_lua_lines'] // 300, 35)
        )
        memory_score = (
            s['map_bytes'] / (50 * 1024 * 1024)
            + s['texture_bytes'] / (250 * 1024 * 1024)
            + s['model_bytes'] / (100 * 1024 * 1024)
            + s['sound_bytes'] / (500 * 1024 * 1024)
            + s['lua_lines'] / 10000
        )
        s['cpu_score'] = round(runtime_score, 2)
        s['memory_score'] = round(memory_score, 2)
        s['event_hooks'] = dict(s['event_hooks'])
        s['pattern_counts'] = dict(s['pattern_counts'])
        s['hot_files'] = sorted(s['hot_files'], key=lambda x: x['score'], reverse=True)[:30]
        stats[mod_id] = s

    report = {
        'mods': stats,
        'exact_log_object_hits': exact_hits,
        'cpu_ranking': sorted(({'mod': k, 'score': v['cpu_score'], 'server_lua_lines': v['server_lua_lines'], 'events': v['event_hooks'], 'patterns': v['pattern_counts']} for k, v in stats.items()), key=lambda x: x['score'], reverse=True),
        'memory_ranking': sorted(({'mod': k, 'score': v['memory_score'], 'bytes': v['bytes'], 'map_bytes': v['map_bytes'], 'texture_bytes': v['texture_bytes'], 'model_bytes': v['model_bytes'], 'sound_bytes': v['sound_bytes']} for k, v in stats.items()), key=lambda x: x['score'], reverse=True),
    }
    return report, all_hits


def human(n: int) -> str:
    units = ['B', 'KiB', 'MiB', 'GiB']
    x = float(n)
    for u in units:
        if x < 1024 or u == units[-1]:
            return f'{x:.1f} {u}'
        x /= 1024
    return f'{n} B'


def render(report: dict) -> str:
    out = ['# Diagnóstico de lag y coste por mod', '', '## Candidatos CPU', '', '| Mod | Puntuación | Lua servidor | Eventos / patrones relevantes |', '|---|---:|---:|---|']
    for row in report['cpu_ranking'][:25]:
        details = []
        if row['events']:
            details.append('eventos=' + json.dumps(row['events'], ensure_ascii=False, separators=(',', ':')))
        important = {k:v for k,v in row['patterns'].items() if v}
        if important:
            details.append('patrones=' + json.dumps(important, ensure_ascii=False, separators=(',', ':')))
        out.append(f"| `{row['mod']}` | {row['score']} | {row['server_lua_lines']} | {'; '.join(details) or '—'} |")
    out += ['', '## Candidatos RAM / carga de assets', '', '| Mod | Puntuación | Total | Mapas | Texturas | Modelos | Sonido |', '|---|---:|---:|---:|---:|---:|---:|']
    for row in report['memory_ranking'][:25]:
        out.append(f"| `{row['mod']}` | {row['score']} | {human(row['bytes'])} | {human(row['map_bytes'])} | {human(row['texture_bytes'])} | {human(row['model_bytes'])} | {human(row['sound_bytes'])} |")
    out += ['', '## Objetos mencionados por el log', '']
    for obj, hits in report['exact_log_object_hits'].items():
        out += [f'### `{obj}`', '']
        if not hits:
            out.append('Sin coincidencias en el repositorio.')
        for hit in hits[:50]:
            out.append(f"- `{hit['mod']}` — `{hit['path']}:{hit['line']}` — `{hit['text']}`")
        out.append('')
    out += ['## Archivos calientes por mod', '']
    for row in report['cpu_ranking'][:20]:
        mod = report['mods'][row['mod']]
        if not mod['hot_files']:
            continue
        out.append(f"### `{row['mod']}`")
        out.append('')
        for f in mod['hot_files'][:15]:
            out.append(f"- {f['score']} — `{f['path']}` — {json.dumps(f['reasons'], ensure_ascii=False)}")
        out.append('')
    out += ['## Alcance', '', 'La puntuación es heurística: sirve para priorizar inspección. No sustituye un perfilador de CPU/JVM ni demuestra consumo real por sí sola.', '']
    return '\n'.join(out)


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument('root', nargs='?', type=Path, default=Path(__file__).resolve().parents[1])
    p.add_argument('--output', type=Path, default=Path(__file__).with_name('diagnostico_lag_servidor'))
    args = p.parse_args()
    report, hits = scan(args.root.resolve())
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.with_suffix('.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    args.output.with_suffix('.md').write_text(render(report), encoding='utf-8')
    print(f"Analizados {len(report['mods'])} mods. Candidato CPU: {report['cpu_ranking'][0]['mod'] if report['cpu_ranking'] else 'ninguno'}")
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
