#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from collections import Counter, defaultdict
from pathlib import Path

BUILD = (42, 20, 0)
TEXT_EXT = {'.lua', '.txt', '.xml', '.json', '.ini', '.cfg', '.properties'}
VERSION_RE = re.compile(r'^\d+(?:\.\d+)*$')
LOG_OBJECTS = [
    'Wooden_Windows', 'Commercial_GridGlassBlackWall', 'DoubleWireGate',
    'SandFloor', 'GravelFloor', 'WoodFloorLvl2', 'WoodFloorLvl3'
]
EVENT_WEIGHTS = {
    'OnTick': 50, 'OnZombieUpdate': 50, 'OnPlayerUpdate': 28,
    'OnPlayerMove': 30, 'OnLoadGridSquare': 35, 'LoadGridsquare': 35,
    'OnObjectAdded': 20, 'OnObjectAboutToBeRemoved': 15,
    'EveryOneMinute': 10, 'EveryTenMinutes': 4, 'EveryHours': 2,
    'OnClientCommand': 12, 'OnServerCommand': 12,
    'OnEnterVehicle': 10, 'OnExitVehicle': 10,
}
PATTERNS = {
    'network': re.compile(r'sendClientCommand|sendServerCommand|transmit|UdpConnection|sendObjectChange', re.I),
    'vehicle': re.compile(r'getVehicle\(|IsoVehicle|VehicleManager|VehicleRequest|OnEnterVehicle|OnExitVehicle', re.I),
    'zombie_loop': re.compile(r'getZombieList\(|getZombies\(|getCell\(\):getZombieList|OnZombieUpdate', re.I),
    'player_loop': re.compile(r'getOnlinePlayers\(|getPlayers\(|OnPlayerUpdate|OnPlayerMove', re.I),
    'tier_zone': re.compile(r'zombie.{0,20}tier|tier.{0,20}zombie|zone.{0,20}tier|tier.{0,20}zone', re.I),
    'spriteconfig': re.compile(r'SpriteConfig', re.I),
}


def read_text(path: Path) -> str:
    raw = path.read_bytes()
    for enc in ('utf-8-sig', 'utf-8', 'utf-16', 'cp1252'):
        try:
            return raw.decode(enc)
        except UnicodeError:
            pass
    return raw.decode('utf-8', errors='replace')


def version_tuple(name: str) -> tuple[int, ...]:
    p = tuple(int(x) for x in name.split('.'))
    return p + (0,) * (3 - len(p))


def parse_mod_id(mod_root: Path) -> str:
    ids = []
    for info in mod_root.rglob('mod.info'):
        if 'media' in {p.lower() for p in info.relative_to(mod_root).parts}:
            continue
        for line in read_text(info).splitlines():
            if line.strip().lower().startswith('id='):
                ids.append(line.split('=', 1)[1].strip())
    return Counter(ids).most_common(1)[0][0] if ids else mod_root.name


def discover(root: Path) -> dict[str, Path]:
    out = {}
    for mods_dir in root.glob('*/Contents/mods'):
        if not mods_dir.is_dir():
            continue
        for mod_root in mods_dir.iterdir():
            if mod_root.is_dir():
                out[parse_mod_id(mod_root)] = mod_root
    return out


def active_files(mod_root: Path) -> dict[str, tuple[Path, str]]:
    layers: list[tuple[str, Path]] = []
    for name, media in [('root', mod_root / 'media'), ('common', mod_root / 'common' / 'media')]:
        if media.is_dir():
            layers.append((name, media))
    versions = sorted(
        [p for p in mod_root.iterdir() if p.is_dir() and VERSION_RE.fullmatch(p.name) and version_tuple(p.name) <= BUILD],
        key=lambda p: version_tuple(p.name),
    )
    if versions and (versions[-1] / 'media').is_dir():
        layers.append((versions[-1].name, versions[-1] / 'media'))
    files: dict[str, tuple[Path, str]] = {}
    for layer, media in layers:
        for path in media.rglob('*'):
            if path.is_file():
                virtual = 'media/' + path.relative_to(media).as_posix().lower()
                files[virtual] = (path, layer)
    return files


def rel(path: Path, root: Path) -> str:
    try:
        return path.relative_to(root).as_posix()
    except ValueError:
        return path.as_posix()


def scope_of(virtual: str) -> str:
    if virtual.startswith('media/lua/server/'):
        return 'server'
    if virtual.startswith('media/lua/shared/'):
        return 'shared'
    if virtual.startswith('media/lua/client/'):
        return 'client'
    return 'data'


def count_events(text: str) -> Counter:
    out = Counter()
    for event in EVENT_WEIGHTS:
        n = len(re.findall(rf'Events\.{re.escape(event)}\.Add\s*\(', text))
        if n:
            out[event] = n
    return out


def human(n: int) -> str:
    x = float(n)
    for u in ('B', 'KiB', 'MiB', 'GiB'):
        if x < 1024 or u == 'GiB':
            return f'{x:.1f} {u}'
        x /= 1024
    return str(n)


def scan(root: Path) -> dict:
    mods = discover(root)
    result = {}
    object_hits = defaultdict(list)
    map_roots = []

    for mod_id, mod_root in sorted(mods.items()):
        files = active_files(mod_root)
        s = {
            'id': mod_id, 'root': rel(mod_root, root), 'active_files': len(files),
            'active_bytes': 0, 'server_lua_lines': 0, 'shared_lua_lines': 0, 'client_lua_lines': 0,
            'server_events': Counter(), 'client_events': Counter(),
            'server_patterns': Counter(), 'client_patterns': Counter(),
            'network_calls': 0, 'map_bytes': 0, 'tile_bytes': 0,
            'texture_bytes': 0, 'model_bytes': 0, 'sound_bytes': 0,
            'map_paths': [], 'hot_server_files': [], 'hot_client_files': [],
        }
        for virtual, (path, layer) in files.items():
            try:
                size = path.stat().st_size
            except OSError:
                size = 0
            s['active_bytes'] += size
            ext = path.suffix.lower()
            low = virtual.lower()
            if low.startswith('media/maps/') or ext in {'.lotpack', '.lotheader'}:
                s['map_bytes'] += size
                s['map_paths'].append(rel(path, root))
            if ext in {'.pack', '.tiles'} or 'tiledef' in low:
                s['tile_bytes'] += size
            if ext in {'.png', '.dds', '.jpg', '.jpeg'}:
                s['texture_bytes'] += size
            if ext in {'.fbx', '.x', '.xmodel', '.mesh'} or '/models/' in low:
                s['model_bytes'] += size
            if ext in {'.ogg', '.wav', '.mp3'}:
                s['sound_bytes'] += size
            if ext not in TEXT_EXT:
                continue
            text = read_text(path)
            lines = len(text.splitlines())
            scope = scope_of(virtual)
            events = count_events(text) if ext == '.lua' else Counter()
            pattern_counts = Counter({k: len(rx.findall(text)) for k, rx in PATTERNS.items()})
            pattern_counts += Counter()
            if scope in {'server', 'shared'}:
                if scope == 'server': s['server_lua_lines'] += lines
                else: s['shared_lua_lines'] += lines
                s['server_events'].update(events)
                s['server_patterns'].update(pattern_counts)
                score = sum(EVENT_WEIGHTS[k] * v for k, v in events.items())
                score += pattern_counts['zombie_loop'] * 22 + pattern_counts['player_loop'] * 10
                score += pattern_counts['network'] * 5 + pattern_counts['vehicle'] * 4
                if score:
                    s['hot_server_files'].append({'path': rel(path, root), 'scope': scope, 'score': score, 'events': dict(events), 'patterns': dict(pattern_counts)})
            if scope in {'client', 'shared'}:
                if scope == 'client': s['client_lua_lines'] += lines
                s['client_events'].update(events)
                s['client_patterns'].update(pattern_counts)
                score = sum(EVENT_WEIGHTS[k] * v for k, v in events.items())
                score += pattern_counts['zombie_loop'] * 10 + pattern_counts['player_loop'] * 8
                score += pattern_counts['network'] * 3 + pattern_counts['vehicle'] * 3 + pattern_counts['tier_zone'] * 2
                if score:
                    s['hot_client_files'].append({'path': rel(path, root), 'scope': scope, 'score': score, 'events': dict(events), 'patterns': dict(pattern_counts)})
            s['network_calls'] += pattern_counts['network']
            for obj in LOG_OBJECTS:
                if obj.lower() in text.lower():
                    for i, line in enumerate(text.splitlines(), 1):
                        if obj.lower() in line.lower():
                            object_hits[obj].append({'mod': mod_id, 'path': rel(path, root), 'line': i, 'text': line.strip()[:220]})
            if 'map.info' in low or 'objects.lua' in low or 'worldmap.xml' in low:
                map_roots.append({'mod': mod_id, 'path': rel(path, root), 'size': size})

        s['server_cpu_score'] = round(
            sum(EVENT_WEIGHTS[k] * v for k, v in s['server_events'].items())
            + s['server_patterns']['zombie_loop'] * 22
            + s['server_patterns']['player_loop'] * 10
            + s['server_patterns']['network'] * 5
            + s['server_patterns']['vehicle'] * 4
            + min((s['server_lua_lines'] + s['shared_lua_lines']) / 250, 60), 2)
        s['client_cpu_score'] = round(
            sum(EVENT_WEIGHTS[k] * v for k, v in s['client_events'].items())
            + s['client_patterns']['zombie_loop'] * 10
            + s['client_patterns']['player_loop'] * 8
            + s['client_patterns']['network'] * 3
            + s['client_patterns']['vehicle'] * 3
            + s['client_patterns']['tier_zone'] * 2, 2)
        s['server_ram_pressure'] = round(
            s['map_bytes'] / (25 * 1024 * 1024)
            + s['tile_bytes'] / (50 * 1024 * 1024)
            + (s['server_lua_lines'] + s['shared_lua_lines']) / 8000, 2)
        s['client_asset_pressure'] = round(
            s['texture_bytes'] / (200 * 1024 * 1024)
            + s['model_bytes'] / (100 * 1024 * 1024)
            + s['sound_bytes'] / (400 * 1024 * 1024), 2)
        for key in ('server_events', 'client_events', 'server_patterns', 'client_patterns'):
            s[key] = dict(s[key])
        s['hot_server_files'] = sorted(s['hot_server_files'], key=lambda x: x['score'], reverse=True)[:20]
        s['hot_client_files'] = sorted(s['hot_client_files'], key=lambda x: x['score'], reverse=True)[:20]
        result[mod_id] = s

    return {
        'method': 'Solo archivos activos para Build 42.20; root/common/última carpeta numérica con sustitución por ruta virtual.',
        'mods': result,
        'server_cpu_ranking': sorted(({'mod': k, 'score': v['server_cpu_score'], 'server_lines': v['server_lua_lines'], 'shared_lines': v['shared_lua_lines'], 'events': v['server_events'], 'patterns': v['server_patterns']} for k, v in result.items()), key=lambda x: x['score'], reverse=True),
        'client_cpu_ranking': sorted(({'mod': k, 'score': v['client_cpu_score'], 'events': v['client_events'], 'patterns': v['client_patterns']} for k, v in result.items()), key=lambda x: x['score'], reverse=True),
        'server_ram_ranking': sorted(({'mod': k, 'score': v['server_ram_pressure'], 'map_bytes': v['map_bytes'], 'tile_bytes': v['tile_bytes'], 'lua_lines': v['server_lua_lines'] + v['shared_lua_lines']} for k, v in result.items()), key=lambda x: x['score'], reverse=True),
        'client_asset_ranking': sorted(({'mod': k, 'score': v['client_asset_pressure'], 'textures': v['texture_bytes'], 'models': v['model_bytes'], 'sound': v['sound_bytes']} for k, v in result.items()), key=lambda x: x['score'], reverse=True),
        'network_ranking': sorted(({'mod': k, 'calls': v['network_calls']} for k, v in result.items()), key=lambda x: x['calls'], reverse=True),
        'exact_log_object_hits': object_hits,
        'map_metadata_files': sorted(map_roots, key=lambda x: x['path']),
    }


def render(r: dict) -> str:
    out = ['# Diagnóstico de lag y carga por mod — Build 42.20', '', r['method'], '', '## CPU del servidor', '', '| Mod | Riesgo | Lua servidor | Lua compartido | Eventos |', '|---|---:|---:|---:|---|']
    for x in r['server_cpu_ranking'][:25]:
        out.append(f"| `{x['mod']}` | {x['score']} | {x['server_lines']} | {x['shared_lines']} | `{json.dumps(x['events'], ensure_ascii=False, separators=(',', ':'))}` |")
    out += ['', '## CPU de clientes', '', '| Mod | Riesgo | Eventos |', '|---|---:|---|']
    for x in r['client_cpu_ranking'][:20]:
        out.append(f"| `{x['mod']}` | {x['score']} | `{json.dumps(x['events'], ensure_ascii=False, separators=(',', ':'))}` |")
    out += ['', '## Presión de RAM/chunks del servidor', '', '| Mod | Riesgo | Mapas | Tile packs | Lua servidor+shared |', '|---|---:|---:|---:|---:|']
    for x in r['server_ram_ranking'][:20]:
        out.append(f"| `{x['mod']}` | {x['score']} | {human(x['map_bytes'])} | {human(x['tile_bytes'])} | {x['lua_lines']} |")
    out += ['', '## Assets de cliente', '', '| Mod | Riesgo | Texturas | Modelos | Sonido |', '|---|---:|---:|---:|---:|']
    for x in r['client_asset_ranking'][:20]:
        out.append(f"| `{x['mod']}` | {x['score']} | {human(x['textures'])} | {human(x['models'])} | {human(x['sound'])} |")
    out += ['', '## Tráfico/red potencial', '', '| Mod | Referencias de envío/sincronización |', '|---|---:|']
    for x in r['network_ranking'][:20]:
        out.append(f"| `{x['mod']}` | {x['calls']} |")
    out += ['', '## Objetos exactos del log', '']
    for obj, hits in r['exact_log_object_hits'].items():
        out += [f'### `{obj}`', '']
        for h in hits[:40]:
            out.append(f"- `{h['mod']}` — `{h['path']}:{h['line']}` — `{h['text']}`")
        out.append('')
    out += ['## Metadatos de mapas encontrados', '']
    for h in r['map_metadata_files']:
        out.append(f"- `{h['mod']}` — `{h['path']}` — {human(h['size'])}")
    out += ['', '## Limitación', '', 'Las puntuaciones priorizan inspección estática. El consumo real debe confirmarse con tiempos de tick, heap y registros del servidor después del despliegue.', '']
    return '\n'.join(out)


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument('root', nargs='?', type=Path, default=Path(__file__).resolve().parents[1])
    p.add_argument('--output', type=Path, default=Path(__file__).with_name('diagnostico_lag_servidor'))
    a = p.parse_args()
    report = scan(a.root.resolve())
    a.output.parent.mkdir(parents=True, exist_ok=True)
    a.output.with_suffix('.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    a.output.with_suffix('.md').write_text(render(report), encoding='utf-8')
    print('Diagnóstico B42.20:', report['server_cpu_ranking'][0]['mod'], report['server_cpu_ranking'][0]['score'])
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
