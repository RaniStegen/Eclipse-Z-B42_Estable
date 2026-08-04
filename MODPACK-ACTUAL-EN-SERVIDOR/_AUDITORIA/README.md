# Auditoría del modpack actual

Esta carpeta contiene la configuración de referencia del servidor y un auditor estático para comprobar el contenido real de `MODPACK-ACTUAL-EN-SERVIDOR`.

## Qué comprueba

- Los siete Workshop Items configurados y sus identificadores.
- Que cada ID incluido en `Mods=` exista en el modpack.
- IDs duplicados o inconsistentes entre carpetas y versiones.
- Dependencias `require=` ausentes.
- Orden final obligatorio: `ECZ_Mods;ECZ_Idioma`.
- Presencia de la carpeta de mapa `Cathaya Valley2.0`.
- Sintaxis, codificación UTF-8 y claves duplicadas de todos los JSON.
- Mojibake en traducciones españolas (`Ã`, `Â`, `â`, `ð`, `�`).
- Marcadores peligrosos como `%d` o `%s` dentro de traducciones.
- La clave crítica `UI_servers_refresh_timer`, que debe utilizar `%1`.
- Solapamientos entre `ECZ_Idioma` y `ECZ_Mods`.
- Archivos de copia de seguridad distribuidos dentro de `Contents`.
- Entidades duplicadas y rutas virtuales sensibles sobrescritas por varios mods.

## Ejecución local

Desde la raíz del repositorio:

```bash
python MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/auditar_modpack.py
```

El proceso genera:

```text
MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/resultado_auditoria.json
MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/resultado_auditoria.md
```

Para convertir también las advertencias en fallo:

```bash
python MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/auditar_modpack.py --strict
```

## GitHub Actions

El flujo `.github/workflows/auditoria-modpack.yml` ejecuta la auditoría cuando cambia el modpack y adjunta los informes como artefacto `auditoria-modpack`.

## Regla del menú multijugador

`ECZ_Idioma` debe estar:

1. Al final de la lista `Mods=` del servidor, después de `ECZ_Mods`.
2. Activado localmente desde el menú principal de cada cliente.

La carga del menú multijugador ocurre antes de que el cliente reciba la lista de mods del servidor. Por eso el arreglo de `UI_servers_refresh_timer` no se aplica al menú si `ECZ_Idioma` no está activado localmente.
