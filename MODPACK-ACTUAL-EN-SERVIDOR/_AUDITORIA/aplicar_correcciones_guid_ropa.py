#!/usr/bin/env python3
"""Corrige conflictos demostrados de GUID en fileGuidTable y clothing.xml.

Criterios:
- Una misma ruta conserva el GUID con mayor consenso entre mods.
- Un GUID no puede apuntar a dos rutas; las rutas posteriores reciben UUID5.
- Un GUID de outfit puede compartirse entre variantes masculina/femenina del
  mismo nombre, pero nunca entre nombres de outfit distintos.
"""
from __future__ import annotations

import json
import re
import uuid
import xml.etree.ElementTree as ET
from collections import Counter, defaultdict
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
CONFIG=Path(__file__).with_name('configuracion_servidor_actual.json')
NS=uuid.UUID('3b4ec769-b602-4dd2-b949-e733adc0258b')
VERSION_RE=re.compile(r'^\d+(?:\.\d+)*$')
FILE_BLOCK_RE=re.compile(r'(?P<block><files>\s*<path>(?P<path>[^<]+)</path>\s*<guid>(?P<guid>[^<]+)</guid>\s*</files>)',re.I)
OUTFIT_RE=re.compile(r'(?P<block><m_(?P<gender>Male|Female)Outfits>.*?</m_(?P=gender)Outfits>)',re.I|re.S)
NAME_RE=re.compile(r'<m_Name>([^<]+)</m_Name>',re.I)
OGUID_RE=re.compile(r'<m_Guid>([^<]+)</m_Guid>',re.I)
ITEM_GUID_RE=re.compile(r'<itemGUID>([^<]+)</itemGUID>',re.I)

def vt(v):
    x=tuple(map(int,v.split('.')));return x+(0,)*(4-len(x))

def read(path):
    raw=path.read_bytes()
    for enc in ('utf-8-sig','utf-16','cp1252'):
        try:return raw.decode(enc)
        except UnicodeError:pass
    return raw.decode('utf-8',errors='replace')

def write(path,text):
    path.write_text(text,encoding='utf-8')

def mod_id(info):
    for line in read(info).splitlines():
        if line.strip().startswith('id='):return line.split('=',1)[1].strip()
    return None

def discover(build):
    out={}
    for modsdir in ROOT.glob('*/Contents/mods'):
        if not modsdir.is_dir():continue
        for modroot in modsdir.iterdir():
            if not modroot.is_dir():continue
            ids=set()
            for info in modroot.rglob('mod.info'):
                if 'media' in {p.lower() for p in info.relative_to(modroot).parts}:continue
                i=mod_id(info)
                if i:ids.add(i)
            if len(ids)!=1:continue
            mid=next(iter(ids));versions=sorted((p for p in modroot.iterdir() if p.is_dir() and VERSION_RE.fullmatch(p.name) and vt(p.name)<=vt(build)),key=lambda p:vt(p.name))
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

def file_entries(path,mid):
    result=[]
    for index,m in enumerate(FILE_BLOCK_RE.finditer(read(path))):
        result.append({'mod':mid,'file':path,'index':index,'path':m.group('path').strip().replace('\\','/').lower(),'guid':m.group('guid').strip().lower(),'block':m.group('block')})
    return result

def outfit_entries(path,mid):
    result=[]
    for index,m in enumerate(OUTFIT_RE.finditer(read(path))):
        block=m.group('block');nm=NAME_RE.search(block);gm=OGUID_RE.search(block)
        if not nm or not gm:continue
        result.append({'mod':mid,'file':path,'index':index,'gender':m.group('gender').lower(),'name':nm.group(1).strip(),'guid':gm.group(1).strip().lower(),'block':block})
    return result

def replace_outfit_guid(path,old_guid,name,new_guid):
    text=read(path);count=0
    def repl(match):
        nonlocal count
        block=match.group('block');nm=NAME_RE.search(block);gm=OGUID_RE.search(block)
        if nm and gm and nm.group(1).strip()==name and gm.group(1).strip().lower()==old_guid:
            count+=1
            block=OGUID_RE.sub(f'<m_Guid>{new_guid}</m_Guid>',block,count=1)
        return block
    new=OUTFIT_RE.sub(repl,text)
    if count:write(path,new)
    return count

def add_killa_shirt_reference(path,old_guid,new_guid):
    text=read(path);changed=0
    def repl(match):
        nonlocal changed
        block=match.group('block');nm=NAME_RE.search(block)
        if not nm or nm.group(1).strip()!='AuthenticKilla':return block
        guids=[g.lower() for g in ITEM_GUID_RE.findall(block)]
        if old_guid not in guids or new_guid in guids:return block
        insert=(f'\n\t\t<m_items> <!-- Killa Long T-Shirt: GUID separado por Eclipse-Z -->\n'
                f'\t\t\t<itemGUID>{new_guid}</itemGUID>\n\t\t</m_items>\n')
        close=re.search(r'</m_(?:Male|Female)Outfits>\s*$',block,re.I)
        if not close:return block
        changed+=1
        return block[:close.start()]+insert+block[close.start():]
    new=OUTFIT_RE.sub(repl,text)
    if changed:write(path,new)
    return changed

def main():
    cfg=json.loads(CONFIG.read_text(encoding='utf-8-sig'));order=list(map(str,cfg['mods']));pos={m:i for i,m in enumerate(order)};mods=discover(str(cfg['build']))
    all_files=[];all_outfits=[]
    for mid in order:
        if mid not in mods:continue
        fg=mods[mid]['files'].get('media/fileguidtable.xml')
        if fg:all_files+=file_entries(fg,mid)
        cl=mods[mid]['files'].get('media/clothing/clothing.xml')
        if cl:all_outfits+=outfit_entries(cl,mid)
    report={'file_path_fixes':[],'file_guid_splits':[],'outfit_guid_fixes':[],'killa_reference_added':0}
    # 1. Resolver ruta -> GUID por consenso entre mods y orden estable.
    bypath=defaultdict(list)
    for e in all_files:bypath[e['path']].append(e)
    target_fg=mods['ECZ_25']['files']['media/fileguidtable.xml'];target_text=read(target_fg)
    remove_blocks=[]
    for path,entries in bypath.items():
        guids={e['guid'] for e in entries}
        if len(guids)<=1:continue
        support=Counter()
        for guid in guids:support[guid]=len({e['mod'] for e in entries if e['guid']==guid})
        canonical=sorted(guids,key=lambda g:(-support[g],min(pos.get(e['mod'],9999) for e in entries if e['guid']==g),g))[0]
        for e in entries:
            if e['mod']=='ECZ_25' and e['guid']!=canonical:
                remove_blocks.append(e['block']);report['file_path_fixes'].append({'path':path,'removed_guid':e['guid'],'canonical_guid':canonical})
    for block in remove_blocks:target_text=target_text.replace(block,'',1)
    write(target_fg,target_text)
    # Recargar entradas de ECZ_25 tras limpieza.
    all_files=[]
    for mid in order:
        if mid not in mods:continue
        fg=mods[mid]['files'].get('media/fileguidtable.xml')
        if fg:all_files+=file_entries(fg,mid)
    # 2. Resolver GUID -> varias rutas. El primer path conserva GUID.
    byg=defaultdict(list)
    for e in all_files:byg[e['guid']].append(e)
    for guid,entries in byg.items():
        paths=[]
        for e in sorted(entries,key=lambda x:(pos.get(x['mod'],9999),x['index'],x['path'])):
            if e['path'] not in paths:paths.append(e['path'])
        if len(paths)<=1:continue
        keep=paths[0]
        for path in paths[1:]:
            affected=[e for e in entries if e['path']==path]
            for e in affected:
                new_guid=str(uuid.uuid5(NS,f'file:{e["mod"]}:{path}'))
                text=read(e['file']);old_block=e['block'];new_block=re.sub(r'(<guid>)[^<]+(</guid>)',rf'\g<1>{new_guid}\g<2>',old_block,flags=re.I)
                text=text.replace(old_block,new_block,1);write(e['file'],text)
                report['file_guid_splits'].append({'mod':e['mod'],'path':path,'old_guid':guid,'new_guid':new_guid,'kept_path':keep})
                if e['mod']=='ECZ_25' and path=='media/clothing/clothingitems/tshirt_sportkillalong.xml':
                    report['killa_reference_added']+=add_killa_shirt_reference(mods['ECZ_25']['files']['media/clothing/clothing.xml'],guid,new_guid)
    # 3. Resolver GUID de outfit compartido por nombres distintos.
    all_outfits=[]
    for mid in order:
        if mid not in mods:continue
        cl=mods[mid]['files'].get('media/clothing/clothing.xml')
        if cl:all_outfits+=outfit_entries(cl,mid)
    byguid=defaultdict(list)
    for e in all_outfits:byguid[e['guid']].append(e)
    for guid,entries in byguid.items():
        groups=[]
        for e in sorted(entries,key=lambda x:(pos.get(x['mod'],9999),x['index'])):
            key=(e['mod'],e['name'])
            if key not in groups:groups.append(key)
        if len(groups)<=1:continue
        canonical=groups[0]
        for mid,name in groups[1:]:
            new_guid=str(uuid.uuid5(NS,f'outfit:{mid}:{name}'))
            path=mods[mid]['files']['media/clothing/clothing.xml']
            changed=replace_outfit_guid(path,guid,name,new_guid)
            if changed:report['outfit_guid_fixes'].append({'mod':mid,'name':name,'old_guid':guid,'new_guid':new_guid,'blocks_changed':changed,'canonical':{'mod':canonical[0],'name':canonical[1]}})
    # Validación final básica.
    report_path=Path(__file__).with_name('CORRECCIONES_GUID_ROPA.json')
    report_path.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'path_fixes':len(report['file_path_fixes']),'guid_splits':len(report['file_guid_splits']),'outfit_fixes':len(report['outfit_guid_fixes']),'killa_added':report['killa_reference_added']},ensure_ascii=False))

if __name__=='__main__':main()
