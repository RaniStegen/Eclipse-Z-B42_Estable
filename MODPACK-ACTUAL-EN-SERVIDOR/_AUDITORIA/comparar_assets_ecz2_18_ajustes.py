#!/usr/bin/env python3
from __future__ import annotations
import argparse, hashlib, json, re
from pathlib import Path
BUILD=(42,20,0); VR=re.compile(r'^\d+(?:\.\d+)*$')
def vt(s):
 p=tuple(int(x) for x in s.split('.')); return p+(0,)*(3-len(p))
def active(root):
 layers=[]
 for n,p in [('root',root/'media'),('common',root/'common'/'media')]:
  if p.is_dir():layers.append((n,p))
 vs=sorted([p for p in root.iterdir() if p.is_dir() and VR.fullmatch(p.name) and vt(p.name)<=BUILD],key=lambda p:vt(p.name))
 if vs and (vs[-1]/'media').is_dir():layers.append((vs[-1].name,vs[-1]/'media'))
 out={}
 for layer,media in layers:
  for p in media.rglob('*'):
   if p.is_file():
    v='media/'+p.relative_to(media).as_posix().lower(); out[v]={'path':p,'layer':layer,'sha':hashlib.sha256(p.read_bytes()).hexdigest(),'size':p.stat().st_size}
 return out
def is_model(v):return '/models/' in v or Path(v).suffix.lower() in {'.fbx','.x','.xmodel','.mesh'}
def main():
 p=argparse.ArgumentParser();p.add_argument('root',nargs='?',type=Path,default=Path(__file__).resolve().parents[1]);p.add_argument('--output',type=Path,default=Path(__file__).with_name('comparacion_assets_ecz2_18_ajustes'));a=p.parse_args();root=a.root.resolve()
 roots={m:list(root.glob(f'*/Contents/mods/{m}'))[0] for m in ('ECZ2_18','ECZ2_Ajustes')}; files={m:active(r) for m,r in roots.items()};A=files['ECZ2_18'];B=files['ECZ2_Ajustes'];ma={k:v for k,v in A.items() if is_model(k)};mb={k:v for k,v in B.items() if is_model(k)}
 common=sorted(set(ma)&set(mb));ident=[x for x in common if ma[x]['sha']==mb[x]['sha']];diff=[x for x in common if ma[x]['sha']!=mb[x]['sha']];onlya=sorted(set(ma)-set(mb));onlyb=sorted(set(mb)-set(ma))
 by_hash_a={v['sha']:[] for v in ma.values()};by_hash_b={v['sha']:[] for v in mb.values()}
 for k,v in ma.items():by_hash_a.setdefault(v['sha'],[]).append(k)
 for k,v in mb.items():by_hash_b.setdefault(v['sha'],[]).append(k)
 same_hashes=set(by_hash_a)&set(by_hash_b);hash_matches=[]
 for h in sorted(same_hashes):hash_matches.append({'sha':h,'A':by_hash_a[h],'B':by_hash_b[h],'size':next(v['size'] for v in ma.values() if v['sha']==h)})
 report={'counts':{'A_models':len(ma),'B_models':len(mb),'A_bytes':sum(v['size'] for v in ma.values()),'B_bytes':sum(v['size'] for v in mb.values()),'same_path':len(common),'same_path_identical':len(ident),'same_path_different':len(diff),'only_A':len(onlya),'only_B':len(onlyb),'shared_hashes':len(same_hashes),'shared_hash_bytes':sum(x['size'] for x in hash_matches)},'same_path_identical':[{'virtual':x,'sha':ma[x]['sha'],'size':ma[x]['size'],'B_path':str(mb[x]['path'].relative_to(root)).replace('\\','/')} for x in ident],'same_path_different':[{'virtual':x,'A':ma[x]['sha'],'B':mb[x]['sha']} for x in diff],'only_A':onlya,'only_B':onlyb,'hash_matches':hash_matches}
 a.output.parent.mkdir(parents=True,exist_ok=True);a.output.with_suffix('.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');c=report['counts'];lines=['# Comparación de modelos ECZ2_18 / ECZ2_Ajustes','',f"ECZ2_18: {c['A_models']} modelos / {c['A_bytes']} bytes",f"ECZ2_Ajustes: {c['B_models']} modelos / {c['B_bytes']} bytes",f"Misma ruta y hash: {c['same_path_identical']}",f"Misma ruta, distinto hash: {c['same_path_different']}",f"Bytes compartidos por hash: {c['shared_hash_bytes']}",'','## Idénticos por ruta','']+[f"- `{x['virtual']}` — {x['size']}" for x in report['same_path_identical']];a.output.with_suffix('.md').write_text('\n'.join(lines)+'\n',encoding='utf-8');print(json.dumps(c))
if __name__=='__main__':main()
