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
  if p.is_dir(): layers.append((n,p))
 vs=sorted([p for p in root.iterdir() if p.is_dir() and VR.fullmatch(p.name) and vt(p.name)<=BUILD],key=lambda p:vt(p.name))
 if vs and (vs[-1]/'media').is_dir(): layers.append((vs[-1].name,vs[-1]/'media'))
 out={}
 for layer,media in layers:
  for p in media.rglob('*'):
   if p.is_file(): out['media/'+p.relative_to(media).as_posix().lower()]={'path':p,'layer':layer,'sha':hashlib.sha256(p.read_bytes()).hexdigest(),'size':p.stat().st_size}
 return out
def main():
 p=argparse.ArgumentParser(); p.add_argument('root',nargs='?',type=Path,default=Path(__file__).resolve().parents[1]); p.add_argument('--output',type=Path,default=Path(__file__).with_name('comparacion_frameworks_armas')); a=p.parse_args(); root=a.root.resolve()
 roots={}
 for mid in ('ECZ_7.1','ECZ_18.2'):
  found=list(root.glob(f'*/Contents/mods/{mid}'))
  if not found: raise SystemExit(f'Falta {mid}')
  roots[mid]=found[0]
 files={k:active(v) for k,v in roots.items()}; A=files['ECZ_7.1']; B=files['ECZ_18.2']
 common=sorted(set(A)&set(B)); identical=[x for x in common if A[x]['sha']==B[x]['sha']]; different=[x for x in common if A[x]['sha']!=B[x]['sha']]
 onlyA=sorted(set(A)-set(B)); onlyB=sorted(set(B)-set(A))
 lua=lambda x:x.startswith('media/lua/')
 report={'counts':{'A':len(A),'B':len(B),'common':len(common),'identical':len(identical),'different':len(different),'only_A':len(onlyA),'only_B':len(onlyB),'lua_common':sum(lua(x) for x in common),'lua_identical':sum(lua(x) for x in identical),'lua_different':sum(lua(x) for x in different),'lua_only_A':sum(lua(x) for x in onlyA),'lua_only_B':sum(lua(x) for x in onlyB)},'different':[{'virtual':x,'A':A[x]['sha'],'B':B[x]['sha']} for x in different],'only_A':[{'virtual':x,'sha':A[x]['sha'],'size':A[x]['size']} for x in onlyA],'only_B':[{'virtual':x,'sha':B[x]['sha'],'size':B[x]['size']} for x in onlyB],'identical_lua':[{'virtual':x,'sha':A[x]['sha'],'size':A[x]['size']} for x in identical if lua(x)]}
 a.output.parent.mkdir(parents=True,exist_ok=True); a.output.with_suffix('.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 c=report['counts']; lines=['# Comparación ECZ_7.1 / ECZ_18.2','',f"Archivos activos: {c['A']} / {c['B']}",f"Lua común: {c['lua_common']}",f"Lua idéntico: {c['lua_identical']}",f"Lua diferente: {c['lua_different']}",f"Lua exclusivo ECZ_7.1: {c['lua_only_A']}",f"Lua exclusivo ECZ_18.2: {c['lua_only_B']}",'','## Lua idéntico','']
 lines += [f"- `{x['virtual']}` — `{x['sha']}`" for x in report['identical_lua']]
 lines += ['','## Diferentes','']+[f"- `{x['virtual']}`" for x in report['different']]
 lines += ['','## Exclusivos ECZ_7.1','']+[f"- `{x['virtual']}`" for x in report['only_A']]
 lines += ['','## Exclusivos ECZ_18.2','']+[f"- `{x['virtual']}`" for x in report['only_B']]
 a.output.with_suffix('.md').write_text('\n'.join(lines)+'\n',encoding='utf-8'); print(json.dumps(c))
if __name__=='__main__':main()
