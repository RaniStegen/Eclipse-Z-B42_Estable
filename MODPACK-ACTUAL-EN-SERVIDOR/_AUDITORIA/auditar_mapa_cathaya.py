#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

OBJ_RE = re.compile(r'\{\s*name\s*=\s*"([^"]*)"\s*,\s*type\s*=\s*"([^"]*)"\s*,(?P<body>.*?)\}\s*,?', re.S)
FIELD_RE = re.compile(r'\b(x|y|z|width|height)\s*=\s*(-?\d+)')
TARGETS = [(7301,12626,0),(7304,12627,0),(7304,12628,0),(7304,12629,0)]


def parse_objects(text: str):
    out=[]
    for i,m in enumerate(OBJ_RE.finditer(text),1):
        fields={k:int(v) for k,v in FIELD_RE.findall(m.group('body'))}
        out.append({'index':i,'name':m.group(1),'type':m.group(2),**fields,'offset':m.start()})
    return out


def contains(o,x,y,z):
    if o.get('z',0)!=z or 'x' not in o or 'y' not in o: return False
    w=max(o.get('width',1),1); h=max(o.get('height',1),1)
    return o['x'] <= x < o['x']+w and o['y'] <= y < o['y']+h


def main():
    p=argparse.ArgumentParser()
    p.add_argument('root',nargs='?',type=Path,default=Path(__file__).resolve().parents[1])
    p.add_argument('--output',type=Path,default=Path(__file__).with_name('auditoria_mapa_cathaya'))
    a=p.parse_args(); root=a.root.resolve()
    maps=list(root.glob('*/Contents/mods/ECZ_8/**/media/maps/Cathaya Valley2.0'))
    if not maps: raise SystemExit('No se encontró Cathaya Valley2.0')
    mp=maps[0]; obj=mp/'objects.lua'
    text=obj.read_text(encoding='utf-8-sig')
    objects=parse_objects(text)
    by_type={}
    for o in objects: by_type[o['type']]=by_type.get(o['type'],0)+1
    index171=next((o for o in objects if o['index']==171),None)
    targets=[]
    for x,y,z in TARGETS:
        targets.append({'x':x,'y':y,'z':z,'objects':[o for o in objects if contains(o,x,y,z)]})
    empty=[o for o in objects if not o['type']]
    malformed=[o for o in objects if 'x' not in o or 'y' not in o]
    duplicates=[]; seen={}
    for o in objects:
        key=(o.get('name'),o.get('type'),o.get('x'),o.get('y'),o.get('z'),o.get('width'),o.get('height'))
        if key in seen: duplicates.append({'first':seen[key],'duplicate':o})
        else: seen[key]=o
    report={'map_path':str(mp.relative_to(root)),'object_count':len(objects),'types':by_type,'index_171':index171,'targets':targets,'empty_type_count':len(empty),'empty_type_objects':empty,'malformed_count':len(malformed),'duplicates_count':len(duplicates),'duplicates':duplicates[:100]}
    a.output.parent.mkdir(parents=True,exist_ok=True)
    a.output.with_suffix('.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    lines=['# Auditoría de Cathaya Valley2.0','',f"Objetos detectados: **{len(objects)}**",'',f"Objeto 171: `{json.dumps(index171,ensure_ascii=False)}`",'',f"Objetos con tipo vacío: **{len(empty)}**",f"Duplicados exactos: **{len(duplicates)}**",'','## Coordenadas del registro','']
    for t in targets:
        lines += [f"### {t['x']},{t['y']},{t['z']}",'']
        for o in t['objects']: lines.append(f"- índice {o['index']}: `{o['type']}` / `{o['name']}` — x={o.get('x')} y={o.get('y')} w={o.get('width',1)} h={o.get('height',1)}")
        if not t['objects']: lines.append('- Ninguna zona del objects.lua contiene la coordenada.')
        lines.append('')
    lines += ['## Tipos','']
    for k,v in sorted(by_type.items(),key=lambda kv:(-kv[1],kv[0])): lines.append(f'- `{k or "<vacío>"}`: {v}')
    a.output.with_suffix('.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
    print(json.dumps({'objects':len(objects),'index171':index171,'empty':len(empty),'duplicates':len(duplicates)},ensure_ascii=False))
    return 0

if __name__=='__main__': raise SystemExit(main())
