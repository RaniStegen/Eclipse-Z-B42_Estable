#!/usr/bin/env python3
from __future__ import annotations
import argparse, json, re
from collections import Counter, defaultdict
from pathlib import Path

VERSION_RE=re.compile(r'^\d+(?:\.\d+)*$')
BUILD=(42,20,0)

def read(path):
    raw=path.read_bytes()
    for e in ('utf-8-sig','utf-8','utf-16','cp1252'):
        try:return raw.decode(e)
        except UnicodeError:pass
    return raw.decode('utf-8',errors='replace')

def vt(s):
    x=tuple(int(v) for v in s.split('.')); return x+(0,)*(3-len(x))

def info(path):
    d=defaultdict(list)
    for raw in read(path).splitlines():
        line=raw.strip()
        if not line or line.startswith(('#','--','//')) or '=' not in line:continue
        k,v=line.split('=',1); d[k.strip().lower()].append(v.strip())
    return dict(d)

def main():
    p=argparse.ArgumentParser(); p.add_argument('root',nargs='?',type=Path,default=Path(__file__).resolve().parents[1]); p.add_argument('--output',type=Path,default=Path(__file__).with_name('inventario_nombres_mods')); a=p.parse_args(); root=a.root.resolve()
    rows=[]
    for modsdir in root.glob('*/Contents/mods'):
        for modroot in sorted(x for x in modsdir.iterdir() if x.is_dir()):
            records=[]
            for f in modroot.rglob('mod.info'):
                if 'media' in {x.lower() for x in f.relative_to(modroot).parts}:continue
                d=info(f)
                if d.get('id'):
                    records.append((f,d))
            ids=[d['id'][0] for _,d in records if len(d.get('id',[]))==1]
            if not ids:continue
            mid=Counter(ids).most_common(1)[0][0]
            names=[]
            for _,d in records:
                names.extend(d.get('name',[]))
            versions=sorted([x.name for x in modroot.iterdir() if x.is_dir() and VERSION_RE.fullmatch(x.name) and vt(x.name)<=BUILD],key=vt)
            rows.append({'id':mid,'name':Counter(names).most_common(1)[0][0] if names else modroot.name,'all_names':sorted(set(names)),'root':str(modroot.relative_to(root)).replace('\\','/'),'active_version':versions[-1] if versions else 'root/common','mod_info_files':[str(f.relative_to(root)).replace('\\','/') for f,_ in records]})
    rows=sorted(rows,key=lambda r:r['id'].lower())
    a.output.parent.mkdir(parents=True,exist_ok=True)
    a.output.with_suffix('.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    lines=['# Inventario de mods activos','', '| ID | Nombre | Versión activa |','|---|---|---|']
    for r in rows:lines.append(f"| `{r['id']}` | {r['name']} | `{r['active_version']}` |")
    a.output.with_suffix('.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
    print(f'{len(rows)} mods inventariados')
if __name__=='__main__':main()
