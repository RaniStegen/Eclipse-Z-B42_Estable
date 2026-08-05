#!/usr/bin/env python3
from __future__ import annotations
import argparse, json, re
from collections import Counter, defaultdict
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any

VER = re.compile(r"^\d+(?:\.\d+)*$")
VALID_ID = re.compile(r"^[A-Za-z0-9_.-]+$")
DEP_KEYS = ("require", "requires", "requiredMods")
MULTI_KEYS = {"pack", "tiledef", "require", "requires", "requiredMods", "loadModAfter", "loadModBefore"}

@dataclass
class Finding:
    severity: str
    code: str
    message: str
    path: str | None = None
    mod_id: str | None = None
    details: dict[str, Any] | None = None

def args():
    p=argparse.ArgumentParser()
    p.add_argument("root",nargs="?",type=Path,default=Path(__file__).resolve().parents[1])
    p.add_argument("--config",type=Path,default=Path(__file__).with_name("configuracion_servidor_actual.json"))
    p.add_argument("--output",type=Path,default=Path(__file__).with_name("resultado_modinfo_versiones"))
    return p.parse_args()

def rel(p:Path,root:Path)->str:
    try:return p.relative_to(root).as_posix()
    except ValueError:return p.as_posix()

def vt(v:str)->tuple[int,...]:
    x=tuple(map(int,v.split(".")));return x+(0,)*(4-len(x))

def leq(a:str,b:str)->bool:return vt(a)<=vt(b)

def read(path:Path)->tuple[str,str]:
    raw=path.read_bytes()
    if raw.startswith((b"\xff\xfe",b"\xfe\xff")):return raw.decode("utf-16"),"utf-16"
    try:return raw.decode("utf-8-sig"),"utf-8"
    except UnicodeDecodeError:return raw.decode("cp1252",errors="replace"),"cp1252"

def parse(path:Path):
    text,enc=read(path); fields=defaultdict(list); seen=Counter()
    for raw in text.splitlines():
        line=raw.strip()
        if not line or line.startswith(("#","--","//")) or "=" not in line:continue
        k,v=line.split("=",1); k=k.strip(); fields[k].append(v.strip()); seen[k]+=1
    return dict(fields),sorted(k for k,n in seen.items() if n>1),enc

def deps(fields):
    raw=[v for k in DEP_KEYS for v in fields.get(k,[])]
    out=[]; issues=[]
    for value in raw:
        if "\\" in value:issues.append(f"barra invertida en «{value}»")
        for token in re.split(r"[;,]",value):
            token=token.strip()
            if not token:continue
            clean=token.lstrip("\\/")
            if clean!=token:issues.append(f"prefijo de ruta en «{token}»")
            out.append(clean)
    for d,n in Counter(out).items():
        if n>1:issues.append(f"dependencia repetida «{d}»")
    return list(dict.fromkeys(out)),list(dict.fromkeys(issues)),raw

def info_kind(path:Path,root:Path):
    parts=path.relative_to(root).parent.parts
    if not parts:return "root",None
    if VER.fullmatch(parts[0]):return "version",parts[0]
    if parts[0].lower()=="common":return "common",None
    return "nested",None

def choose(infos,build):
    compatible=[x for x in infos if x["kind"]=="version" and x["version"] and leq(x["version"],build)]
    if compatible:return max(compatible,key=lambda x:(vt(x["version"]),x["path"]))
    for kind in ("root","common","nested"):
        c=[x for x in infos if x["kind"]==kind]
        if c:return sorted(c,key=lambda x:x["path"])[0]
    return None

def topological(mods,dependency_map,tail):
    pos={m:i for i,m in enumerate(mods)}; indeg={m:0 for m in mods}; out=defaultdict(set)
    for m,ds in dependency_map.items():
        for d in ds:
            if m in indeg and d in indeg and m!=d and m not in out[d]:
                out[d].add(m);indeg[m]+=1
    q=sorted([m for m in mods if indeg[m]==0],key=pos.get); result=[]
    while q:
        m=q.pop(0);result.append(m)
        for n in sorted(out[m],key=pos.get):
            indeg[n]-=1
            if indeg[n]==0:q.append(n);q.sort(key=pos.get)
    cycles=[m for m in mods if m not in result];result+=cycles
    t=set(tail);result=[m for m in result if m not in t]+[m for m in tail if m in indeg]
    return result,cycles

def audit(root:Path,cfg):
    build=str(cfg["build"]); line=list(map(str,cfg["mods"])); tail=list(map(str,cfg.get("required_tail_order",[]))); external=set(map(str,cfg.get("external_mods",[])))
    pos={m:i+1 for i,m in enumerate(line)}; findings=[]; folders=[]
    active=defaultdict(list); any_ids=defaultdict(list); depmap={}
    for m,n in Counter(line).items():
        if n>1:findings.append(Finding("error","MODS_DUPLICATE",f"{m} aparece varias veces en Mods=.",mod_id=m))
    for package in sorted(root.iterdir()):
        modsdir=package/"Contents"/"mods"
        if not modsdir.is_dir():continue
        for modroot in sorted(p for p in modsdir.iterdir() if p.is_dir()):
            versions=[];future=[];compatible=[];malformed=[];version_without_info=[]
            for child in sorted(p for p in modroot.iterdir() if p.is_dir()):
                if VER.fullmatch(child.name):
                    versions.append(child.name)
                    (compatible if leq(child.name,build) else future).append(child.name)
                    if not (child/"mod.info").is_file():version_without_info.append(child)
                elif child.name and child.name[0].isdigit():
                    malformed.append(child.name)
                    findings.append(Finding("warning","VERSION_FOLDER_MALFORMED",f"Carpeta de versión no numérica: {child.name}.",rel(child,root),modroot.name))
            infos=[]
            paths=sorted(p for p in modroot.rglob("mod.info") if "media" not in {x.lower() for x in p.relative_to(modroot).parts})
            if not paths:findings.append(Finding("error","MODINFO_MISSING","Carpeta sin mod.info.",rel(modroot,root),modroot.name))
            for p in paths:
                fields,dupes,enc=parse(p); kind,version=info_kind(p,modroot); ds,issues,rawdeps=deps(fields)
                ids=fields.get("id",[]); names=fields.get("name",[])
                item={"path":rel(p,root),"kind":kind,"version":version,"ids":ids,"names":names,"deps":ds,"rawdeps":rawdeps,"fields":fields}
                infos.append(item)
                if enc!="utf-8":findings.append(Finding("warning","MODINFO_ENCODING",f"Codificación {enc}; se recomienda UTF-8.",item["path"],modroot.name))
                bad_dupes=[k for k in dupes if k not in MULTI_KEYS]
                if bad_dupes:findings.append(Finding("error","MODINFO_DUPLICATE_KEYS",f"Claves no multivalor repetidas: {', '.join(bad_dupes)}.",item["path"],modroot.name))
                if len(ids)!=1:findings.append(Finding("error","MODINFO_ID_COUNT","Debe existir un único id=.",item["path"],modroot.name,{"ids":ids}))
                if len(names)!=1 or not names[0]:findings.append(Finding("error","MODINFO_NAME_COUNT","Debe existir un único name= no vacío.",item["path"],modroot.name,{"names":names}))
                for i in ids:
                    any_ids[i].append(item["path"])
                    if not VALID_ID.fullmatch(i):findings.append(Finding("error","MODINFO_ID_INVALID",f"ID inválido: {i}.",item["path"],i))
                for issue in issues:findings.append(Finding("error","DEPENDENCY_FORMAT",issue,item["path"],ids[-1] if ids else modroot.name))
                for asset in ("poster","icon"):
                    vals=fields.get(asset,[])
                    if vals:
                        value=vals[-1]
                        if not ((p.parent/value).is_file() or (modroot/value).is_file()):
                            findings.append(Finding("warning","ASSET_MISSING",f"{asset}={value} no existe.",item["path"],ids[-1] if ids else modroot.name))
            has_generic=any(x["kind"] in ("root","common") for x in infos)
            for missing_version in version_without_info:
                if not has_generic:findings.append(Finding("error","VERSION_WITHOUT_MODINFO",f"{missing_version.name} no contiene mod.info ni existe metadata raíz/common.",rel(missing_version,root),modroot.name))
            selected=choose(infos,build); active_id=None
            if selected and len(selected["ids"])==1:
                active_id=selected["ids"][0];active[active_id].append(rel(modroot,root));depmap[active_id]=selected["deps"]
            declared=sorted({i for x in infos for i in x["ids"]})
            if len(declared)>1:findings.append(Finding("error","IDS_INCONSISTENT",f"La carpeta declara IDs distintos: {', '.join(declared)}.",rel(modroot,root),active_id or modroot.name))
            if active_id and active_id!=modroot.name:
                sev="warning" if active_id.lower()==modroot.name.lower() else "error"
                findings.append(Finding(sev,"FOLDER_ID_MISMATCH",f"La carpeta {modroot.name} declara id={active_id}.",rel(modroot,root),active_id))
            if versions and not compatible and not any(x["kind"] in ("root","common") for x in infos):
                findings.append(Finding("error","NO_COMPATIBLE_VERSION",f"No hay versión compatible con Build {build}.",rel(modroot,root),active_id or modroot.name,{"versions":versions}))
            if future:findings.append(Finding("warning","FUTURE_VERSION",f"Versiones posteriores a {build}: {', '.join(future)}.",rel(modroot,root),active_id or modroot.name))
            folders.append({"package":package.name,"folder":modroot.name,"path":rel(modroot,root),"versions":versions,"compatible":compatible,"future":future,"malformed":malformed,"info_count":len(infos),"active_id":active_id,"active_info":selected["path"] if selected else None,"active_version":(selected["version"] or selected["kind"]) if selected else None,"dependencies":selected["deps"] if selected else []})
    for i,owners in active.items():
        if len(set(owners))>1:findings.append(Finding("error","ACTIVE_ID_DUPLICATED",f"{i} existe en varias carpetas.",mod_id=i,details={"folders":owners}))
    active_ids=set(active); lower={i.lower():i for i in active_ids}
    for idx,m in enumerate(line,1):
        if m in active_ids or m in external:continue
        if m.lower() in lower:findings.append(Finding("error","MODS_CASE_MISMATCH",f"Mods= usa {m}; el ID real es {lower[m.lower()]}.",mod_id=m,details={"position":idx}))
        elif m in any_ids:findings.append(Finding("error","MOD_INACTIVE_FOR_BUILD",f"{m} existe, pero no en el mod.info activo para Build {build}.",mod_id=m,details={"paths":any_ids[m]}))
        else:findings.append(Finding("error","MODS_ID_MISSING",f"{m} no existe en el modpack.",mod_id=m,details={"position":idx}))
    for i in sorted(active_ids-set(line)):findings.append(Finding("warning","ACTIVE_NOT_LISTED",f"{i} existe, pero no figura en Mods=.",mod_id=i,details={"folders":active[i]}))
    for m,ds in depmap.items():
        for d in ds:
            if d==m:findings.append(Finding("error","SELF_DEPENDENCY",f"{m} se requiere a sí mismo.",mod_id=m));continue
            if d not in active_ids and d not in external:
                actual=lower.get(d.lower())
                msg=f"{m} requiere {d}, pero el ID real es {actual}." if actual else f"{m} requiere {d}, pero no existe como mod activo."
                findings.append(Finding("error","DEPENDENCY_MISSING",msg,mod_id=m));continue
            if d not in pos:findings.append(Finding("error","DEPENDENCY_NOT_LISTED",f"{m} requiere {d}, pero no está en Mods=.",mod_id=m));continue
            if m in pos and pos[d]>pos[m]:findings.append(Finding("error","DEPENDENCY_AFTER_MOD",f"{d} está después de {m} en Mods=.",mod_id=m,details={"mod_position":pos[m],"dependency_position":pos[d]}))
    if tail and line[-len(tail):]!=tail:findings.append(Finding("error","TAIL_ORDER",f"El final debe ser {';'.join(tail)}.",details={"actual":line[-len(tail):]}))
    recommended,cycles=topological(line,depmap,tail)
    if cycles:findings.append(Finding("error","DEPENDENCY_CYCLE","Ciclo de dependencias detectado.",details={"mods":cycles}))
    errmods={f.mod_id for f in findings if f.severity=="error"};warnmods={f.mod_id for f in findings if f.severity=="warning"}
    for r in folders:
        r["position"]=pos.get(r["active_id"]);r["status"]="ERROR" if r["active_id"] in errmods or r["folder"] in errmods else ("AVISO" if r["active_id"] in warnmods or r["folder"] in warnmods else "OK")
    stats={"build":build,"mods_line":len(line),"packages":len({r["package"] for r in folders}),"folders":len(folders),"mod_info":sum(r["info_count"] for r in folders),"active_ids":len(active_ids),"external_ids":len(external),"version_folders":sum(len(r["versions"]) for r in folders),"errors":sum(f.severity=="error" for f in findings),"warnings":sum(f.severity=="warning" for f in findings),"recommended":recommended,"order_unchanged":recommended==line}
    return findings,folders,stats

def markdown(findings,folders,stats,cfg):
    line=list(map(str,cfg["mods"])); external=set(map(str,cfg.get("external_mods",[]))); byid={r["active_id"]:r for r in folders if r["active_id"]}
    out=["# Parte 2 — revisión de mod.info, dependencias y versiones","",f"Build: **{stats['build']}**","","## Resumen","",f"- `Mods=`: **{stats['mods_line']}** entradas",f"- Paquetes internos: **{stats['packages']}**",f"- Carpetas internas: **{stats['folders']}**",f"- `mod.info` internos: **{stats['mod_info']}**",f"- IDs internos activos: **{stats['active_ids']}**",f"- IDs externos declarados: **{stats['external_ids']}**",f"- Carpetas de versión: **{stats['version_folders']}**",f"- Errores: **{stats['errors']}**",f"- Advertencias: **{stats['warnings']}**","","## Errores",""]
    errors=[f for f in findings if f.severity=="error"];warnings=[f for f in findings if f.severity=="warning"]
    out+=([f"- **{f.code}**{f' [{f.mod_id}]' if f.mod_id else ''}: {f.message}{f' — `{f.path}`' if f.path else ''}" for f in errors] or ["- Ninguno."])
    out+=["","## Advertencias",""]+([f"- **{f.code}**{f' [{f.mod_id}]' if f.mod_id else ''}: {f.message}{f' — `{f.path}`' if f.path else ''}" for f in warnings] or ["- Ninguna."])
    out+=["","## Comparación exacta con `Mods=`","","| # | ID | Carpeta | `mod.info` activo | Versión | Dependencias | Estado |","|---:|---|---|---|---|---|---|"]
    for n,m in enumerate(line,1):
        r=byid.get(m)
        if not r:
            state="EXTERNO" if m in external else "FALTA"
            out.append(f"| {n} | `{m}` | — | — | — | — | **{state}** |")
            continue
        ds=", ".join(f"`{d}`" for d in r["dependencies"]) or "—"
        out.append(f"| {n} | `{m}` | `{r['path']}` | `{r['active_info']}` | `{r['active_version']}` | {ds} | **{r['status']}** |")
    out+=["","## Inventario de carpetas y versiones","","| Paquete | Carpeta | ID activo | Versiones | Compatibles | Futuras | `mod.info` activo | Estado |","|---|---|---|---|---|---|---|---|"]
    for r in sorted(folders,key=lambda x:(x["package"],x["folder"])):
        out.append(f"| `{r['package']}` | `{r['folder']}` | `{r['active_id'] or '—'}` | {', '.join(r['versions']) or '—'} | {', '.join(r['compatible']) or '—'} | {', '.join(r['future']) or '—'} | `{r['active_info'] or '—'}` | **{r['status']}** |")
    out+=["","## Orden por dependencias",""]
    if stats["order_unchanged"]:out.append("La línea actual ya respeta todas las dependencias detectadas y el final protegido.")
    else:out+=["```ini","Mods="+";".join(stats["recommended"]),"```"]
    out+=["","## Dependencias externas","", "`NewMusic` y `eclipsemusic` se mantienen en `Mods=` y `WorkshopItems=`, pero no forman parte del contenido interno de este repositorio. Se muestran como **EXTERNO** y no se exige que tengan carpeta o `mod.info` aquí.", "", "## Criterio de versión","","Se selecciona la carpeta numérica más alta que no sea posterior a Build 42.20.0. Si no existe, se usa el `mod.info` raíz o `common/mod.info`. `common/media` se considera contenido compartido.",""]
    return "\n".join(out)

def main():
    a=args();cfg=json.loads(a.config.read_text(encoding="utf-8"));f,r,s=audit(a.root.resolve(),cfg);a.output.parent.mkdir(parents=True,exist_ok=True)
    a.output.with_suffix(".json").write_text(json.dumps({"stats":s,"findings":[asdict(x) for x in f],"mods":r},ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
    a.output.with_suffix(".md").write_text(markdown(f,r,s,cfg),encoding="utf-8")
    a.output.with_name(a.output.name+"_Mods.txt").write_text("Mods="+";".join(s["recommended"])+"\n",encoding="utf-8")
    print(f"Parte 2: {s['folders']} carpetas, {s['mod_info']} mod.info, {s['errors']} errores, {s['warnings']} advertencias")
    return 1 if s["errors"] else 0
if __name__=="__main__":raise SystemExit(main())
