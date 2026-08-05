#!/usr/bin/env python3
"""Traza GUID de prendas y outfits en los XML activos del modpack."""
from __future__ import annotations

import argparse
import json
import re
import xml.etree.ElementTree as ET
from collections import defaultdict
from pathlib import Path

VERSION_RE = re.compile(r"^\d+(?:\.\d+)*$")


def args():
    p=argparse.ArgumentParser()
    p.add_argument("root",nargs="?",type=Path,default=Path(__file__).resolve().parents[1])
    p.add_argument("--config",type=Path,default=Path(__file__).with_name("configuracion_servidor_actual.json"))
    p.add_argument("--output",required=True,type=Path)
    return p.parse_args()

def vt(v):
    x=tuple(map(int,v.split('.'))); return x+(0,)*(4-len(x))

def read(path):
    raw=path.read_bytes()
    for enc in ('utf-8-sig','utf-16','cp1252'):
        try:return raw.decode(enc)
        except UnicodeError:pass
    return raw.decode('utf-8',errors='replace')

def parse_info(path):
    for line in read(path).splitlines():
        line=line.strip()
        if line.startswith('id='):return line.split('=',1)[1].strip()
    return None

def mods(root,build):
    out={}
    for modsdir in root.glob('*/Contents/mods'):
        if not modsdir.is_dir():continue
        for modroot in modsdir.iterdir():
            if not modroot.is_dir():continue
            ids=set()
            for info in modroot.rglob('mod.info'):
                if 'media' in {p.lower() for p in info.relative_to(modroot).parts}:continue
                i=parse_info(info)
                if i:ids.add(i)
            if len(ids)!=1:continue
            mid=next(iter(ids))
            versions=sorted((p for p in modroot.iterdir() if p.is_dir() and VERSION_RE.fullmatch(p.name) and vt(p.name)<=vt(build)),key=lambda p:vt(p.name))
            layers=[]
            if (modroot/'media').is_dir():layers.append(modroot/'media')
            if (modroot/'common'/'media').is_dir():layers.append(modroot/'common'/'media')
            if versions and (versions[-1]/'media').is_dir():layers.append(versions[-1]/'media')
            active={}
            for layer in layers:
                for p in layer.rglob('*'):
                    if p.is_file():active[('media/'+p.relative_to(layer).as_posix()).lower()]=p
            out[mid]={'root':modroot,'files':active}
    return out

def childmap(elem):return {c.tag.lower():(c.text or '').strip() for c in list(elem)}

def main():
    a=args();root=a.root.resolve();cfg=json.loads(a.config.read_text(encoding='utf-8-sig')); order=list(map(str,cfg['mods'])); m=mods(root,str(cfg['build']))
    file_entries=[]; refs=defaultdict(list); outfit_ids=defaultdict(list)
    for mid in order:
        if mid not in m:continue
        fg=m[mid]['files'].get('media/fileguidtable.xml')
        if fg:
            xr=ET.parse(fg).getroot()
            for e in xr.iter():
                vals=childmap(e); path=vals.get('path'); guid=vals.get('guid')
                if path and guid:file_entries.append({'mod':mid,'file':str(fg.relative_to(root)).replace('\\','/'),'path':path.replace('\\','/').lower(),'guid':guid.lower()})
        cl=m[mid]['files'].get('media/clothing/clothing.xml')
        if cl:
            xr=ET.parse(cl).getroot()
            for gender,tag in [('female','m_FemaleOutfits'),('male','m_MaleOutfits')]:
                for out in xr.iter(tag):
                    name=(out.findtext('m_Name') or '').strip(); og=(out.findtext('m_Guid') or '').strip().lower()
                    if og:outfit_ids[og].append({'mod':mid,'file':str(cl.relative_to(root)).replace('\\','/'),'gender':gender,'name':name})
                    for n in out.iter('itemGUID'):
                        g=(n.text or '').strip().lower()
                        if g:refs[g].append({'mod':mid,'file':str(cl.relative_to(root)).replace('\\','/'),'gender':gender,'outfit':name,'outfit_guid':og})
    bypath=defaultdict(list); byg=defaultdict(list)
    for e in file_entries:bypath[e['path']].append(e);byg[e['guid']].append(e)
    path_conf={k:v for k,v in bypath.items() if len({e['guid'] for e in v})>1}
    guid_conf={k:v for k,v in byg.items() if len({e['path'] for e in v})>1}
    outfit_conf={k:v for k,v in outfit_ids.items() if len({(e['mod'],e['gender'],e['name']) for e in v})>1 and len({e['name'] for e in v})>1}
    result={'path_conflicts':path_conf,'guid_conflicts':guid_conf,'outfit_guid_conflicts':outfit_conf,'references':{g:refs.get(g,[]) for g in set(guid_conf)|set(outfit_conf)}}
    a.output.parent.mkdir(parents=True,exist_ok=True)
    a.output.with_suffix('.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    lines=['# Diagnóstico de GUID de ropa','','## Conflictos ruta → GUID','']
    for path,entries in path_conf.items():
        lines += [f'### `{path}`','', '```json',json.dumps(entries,ensure_ascii=False,indent=2),'```','']
    lines += ['## Conflictos GUID → ruta','']
    for guid,entries in guid_conf.items():
        lines += [f'### `{guid}`','', '```json',json.dumps({'entries':entries,'outfit_references':refs.get(guid,[])},ensure_ascii=False,indent=2),'```','']
    lines += ['## Conflictos de GUID de outfit','']
    for guid,entries in outfit_conf.items():
        lines += [f'### `{guid}`','', '```json',json.dumps(entries,ensure_ascii=False,indent=2),'```','']
    a.output.with_suffix('.md').write_text('\n'.join(lines),encoding='utf-8')
    print(f'Diagnóstico GUID: {len(path_conf)} rutas, {len(guid_conf)} GUID y {len(outfit_conf)} outfits en conflicto')

if __name__=='__main__':main()
