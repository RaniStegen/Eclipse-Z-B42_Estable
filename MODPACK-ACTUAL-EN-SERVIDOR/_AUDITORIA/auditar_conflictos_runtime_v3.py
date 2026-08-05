#!/usr/bin/env python3
"""Ejecutor corregido del auditor de conflictos por propiedades.

Carga la versión v2, corrige el único cierre de lista mal formado y ejecuta el
mismo código. Se mantiene separado para no introducir cambios funcionales en
la lógica ya auditada.
"""
from pathlib import Path

SOURCE = Path(__file__).with_name("auditar_conflictos_runtime_v2.py")
text = SOURCE.read_text(encoding="utf-8")
bad = 'details={"sources": [{"mod": d["mod"], "path": d["path"]} for d in defs[:20]}))'
good = 'details={"sources": [{"mod": d["mod"], "path": d["path"]} for d in defs[:20]]}))'
if bad not in text:
    raise RuntimeError("No se encontró el cierre mal formado esperado en auditar_conflictos_runtime_v2.py")
text = text.replace(bad, good, 1)
namespace = {"__name__": "__main__", "__file__": str(SOURCE)}
exec(compile(text, str(SOURCE), "exec"), namespace)
