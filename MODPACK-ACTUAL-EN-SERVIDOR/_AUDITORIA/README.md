# Auditoría del modpack actual

Esta carpeta contiene la configuración de referencia del servidor y los auditores estáticos para comprobar el contenido real de `MODPACK-ACTUAL-EN-SERVIDOR`.

## Alcance

El repositorio contiene el modpack propio de Eclipse-Z. Los siguientes elementos son dependencias externas e independientes:

- Workshop Item `3755715727` — mod `NewMusic`.
- Workshop Item `3739256725` — mod `eclipsemusic`.

Deben permanecer en `WorkshopItems=` y `Mods=`, pero no se espera que sus carpetas estén dentro de este repositorio. Los auditores los reconocen como externos y no generan falsos errores por su ausencia física.

## Qué comprueba

- Los cinco Workshop Items internos y los dos externos configurados.
- Que cada ID interno incluido en `Mods=` exista en el modpack.
- IDs duplicados o inconsistentes entre carpetas y versiones.
- Dependencias `require=` ausentes.
- Orden final obligatorio: `ECZ_Mods;ECZ_Idioma`.
- Presencia de la carpeta de mapa `Cathaya Valley2.0`.
- Sintaxis, codificación UTF-8 y claves duplicadas de todos los JSON.
- Mojibake en traducciones españolas (`Ã`, `Â`, `â`, `ð`, `�`).
- La clave crítica `UI_servers_refresh_timer`, que debe utilizar `%1`.
- Solapamientos entre `ECZ_Idioma` y `ECZ_Mods`.
- Archivos de copia de seguridad distribuidos dentro de `Contents`.
- Entidades duplicadas y rutas virtuales sensibles sobrescritas por varios mods.
- Todos los `mod.info`, carpetas de versión y dependencias comparados contra la línea real `Mods=`.

## Ejecución local

Desde la raíz del repositorio:

```bash
python MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/auditar_modpack_v2.py
python MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/auditar_modinfo_versiones.py
```

## GitHub Actions

El flujo `.github/workflows/auditoria-modpack.yml` ejecuta ambas auditorías cuando cambia el modpack y publica los informes como artefactos.

## Regla del menú multijugador

`ECZ_Idioma` debe estar:

1. Al final de la lista `Mods=` del servidor, después de `ECZ_Mods`.
2. Activado localmente desde el menú principal de cada cliente.

La carga del menú multijugador ocurre antes de que el cliente reciba la lista de mods del servidor. Por eso el arreglo de `UI_servers_refresh_timer` no se aplica al menú si `ECZ_Idioma` no está activado localmente.
