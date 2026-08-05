-- ECZ_10 B42.20 — parche v7 neutralizado
-- La versión anterior se cargaba desde media/lua/shared y seguía ejecutándose
-- tanto en cliente como en servidor, aunque las copias de client estuvieran
-- desactivadas. Provocaba recreación/transferencia de componentes en objetos
-- multicasilla.
--
-- Se conserva el archivo para mantener una ruta estable, pero no registra
-- eventos ni modifica entidades.
return
