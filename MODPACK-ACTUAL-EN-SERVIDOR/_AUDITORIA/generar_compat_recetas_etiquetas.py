#!/usr/bin/env python3
"""Genera el parche final de EvolvedRecipe y Tags en ECZ2_Ajustes.

No altera los mods de origen. Fusiona valores acumulables y deja el resultado
en un mod cargado después de todos los proveedores implicados.
"""
from __future__ import annotations

import argparse
import json
import re
from collections import defaultdict
from pathlib import Path

VERSION_RE = re.compile(r"^\d+(?:\.\d+)*$")
MODULE_RE = re.compile(r"^\s*module\s+([A-Za-z0-9_.-]+)\b", re.I)
ITEM_RE = re.compile(r"^\s*item\s+([A-Za-z_][A-Za-z0-9_.-]*)\b", re.I)
PROP_RE = re.compile(r"^\s*(EvolvedRecipe|Tags)\s*=\s*(.*?)\s*,?\s*$", re.I)


def args():
    p=argparse.ArgumentParser()
    p.add_argument("root",nargs="?",type=Path,default=Path(__file__).resolve().parents[1])
    p.add_argument("--config",type=Path,default=Path(__file__).with_name("configuracion_servidor_actual.json"))
    p.add_argument("--target",type=Path)
    p.add_argument("--report",type=Path)
    return p.parse_args()

def vt(v):
    x=tuple(map(int,v.split('.')));return x+(0,)*(4-len(x))

def read(path):
    raw=path.read_bytes()
    for enc in ('utf-8-sig','utf-16','cp1252'):
        try:return raw.decode(enc)
        except UnicodeError:pass
    return raw.decode('utf-8',errors='replace')

def parse_info(path):
    for raw in read(path).splitlines():
        line=raw.strip()
        if line.startswith('id='):return line.split('=',1)[1].strip()
    return None

def discover(root,build):
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
            files={}
            for layer in layers:
                scripts=layer/'scripts'
                if not scripts.is_dir():continue
                for p in scripts.rglob('*.txt'):
                    files[p.relative_to(scripts).as_posix().lower()]=p
            out[mid]={'root':modroot,'files':files}
    return out

def item_blocks(text):
    lines=text.splitlines(); module='?'; depth=0; i=0
    while i<len(lines):
        clean=lines[i].split('//',1)[0]
        mm=MODULE_RE.match(clean)
        if mm and depth==0:module=mm.group(1)
        im=ITEM_RE.match(clean) if depth==1 else None
        if im:
            name=im.group(1); block=[]; cursor=i; opened=0; balance=0
            while cursor<len(lines):
                raw=lines[cursor]; c=raw.split('//',1)[0]; block.append(raw)
                opened+=c.count('{');balance+=c.count('{')-c.count('}');cursor+=1
                if opened and balance<=0:break
            props=defaultdict(list); local_depth=0; started=False
            for raw in block:
                c=raw.split('//',1)[0].strip()
                if started and local_depth==1:
                    pm=PROP_RE.match(c)
                    if pm:props[pm.group(1).lower()].append(pm.group(2).strip().rstrip(','))
                opens=c.count('{');closes=c.count('}')
                if opens:started=True
                local_depth+=opens-closes
            yield module,name,dict(props)
        depth+=clean.count('{')-clean.count('}');depth=max(depth,0);i+=1

def split_tokens(value):
    return [x.strip() for x in value.split(';') if x.strip()]

def merge_recipes(values):
    order=[]; mapping={}
    for value in values:
        for token in split_tokens(value):
            key=token.split(':',1)[0].strip().lower()
            if key not in mapping:order.append(key)
            mapping[key]=token
    return ';'.join(mapping[k] for k in order)

def merge_tags(values):
    seen=set(); out=[]
    for value in values:
        for token in split_tokens(value):
            key=token.lower()
            if key not in seen:seen.add(key);out.append(token)
    return ';'.join(out)

def main():
    a=args();root=a.root.resolve();cfg=json.loads(a.config.read_text(encoding='utf-8-sig'));mods=discover(root,str(cfg['build']));external=set(map(str,cfg.get('external_mods',[])))
    sources=defaultdict(lambda:defaultdict(list))
    for mod_index,mid in enumerate(map(str,cfg['mods'])):
        if mid in external or mid not in mods:continue
        for relpath,path in sorted(mods[mid]['files'].items()):
            # No leer un parche generado anteriormente al recalcular la fuente.
            if path.name.lower()=='zz_ecz_compat_recetas_etiquetas.txt':continue
            for module,item,props in item_blocks(read(path)):
                full=f'{module}.{item}'
                for prop,values in props.items():
                    for value in values:sources[full][prop].append({'mod':mid,'mod_index':mod_index,'path':str(path.relative_to(root)).replace('\\','/'),'value':value})
    merged={}
    for full,properties in sources.items():
        out={}
        for prop,entries in properties.items():
            values=[e['value'] for e in entries]
            if len(set(values))<2:continue
            if prop=='evolvedrecipe':out['EvolvedRecipe']=merge_recipes(values)
            elif prop=='tags':out['Tags']=merge_tags(values)
        if out:merged[full]=out
    bymodule=defaultdict(list)
    for full,props in merged.items():
        module,item=full.split('.',1);bymodule[module].append((item,props))
    lines=['/**',' * ECZ Parte 3 — compatibilidad de recetas y etiquetas.',' * Generado automáticamente a partir de todos los scripts activos de B42.20.',' * El mod ECZ2_Ajustes se carga después de los proveedores y conserva la unión.',' */','']
    for module in sorted(bymodule):
        lines += [f'module {module}','{']
        for item,props in sorted(bymodule[module]):
            lines += [f'    item {item}','    {']
            for key,value in props.items():lines.append(f'        {key} = {value},')
            lines += ['    }','']
        lines += ['}','']
    target=a.target
    if target is None:
        candidates=[]
        for mid,data in mods.items():
            if mid=='ECZ2_Ajustes':candidates.append(data['root'])
        if len(candidates)!=1:raise SystemExit('No se encontró exactamente una carpeta ECZ2_Ajustes')
        target=candidates[0]/'42.18'/'media'/'scripts'/'zz_ECZ_Compat_Recetas_Etiquetas.txt'
    target.parent.mkdir(parents=True,exist_ok=True);target.write_text('\n'.join(lines).rstrip()+'\n',encoding='utf-8')
    report={'target':str(target.relative_to(root)).replace('\\','/'),'items':len(merged),'modules':{m:len(v) for m,v in bymodule.items()},'entries':merged}
    report_path=a.report or Path(__file__).with_name('resultado_compat_recetas_etiquetas.json')
    report_path.parent.mkdir(parents=True,exist_ok=True);report_path.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(f'Compatibilidad generada: {len(merged)} items en {target}')

if __name__=='__main__':main()
