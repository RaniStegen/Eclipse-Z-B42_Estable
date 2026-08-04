# Auditoría del modpack actual

Esta carpeta contiene la configuración de referencia del servidor y las herramientas utilizadas para revisar `MODPACK-ACTUAL-EN-SERVIDOR`.

## Auditor enfocado

El auditor activo es:

```text
auditar_modpack_v2.py
```

Comprueba únicamente problemas que pueden afectar a la carga del servidor, la sincronización con los clientes o la interfaz:

- Los siete Workshop Items configurados y sus identificadores.
- Que cada ID incluido en `Mods=` exista realmente en el modpack.
- IDs duplicados o inconsistentes entre carpetas y versiones.
- Dependencias `require=` ausentes.
- Orden final obligatorio: `ECZ_Mods;ECZ_Idioma`.
- Presencia de `Cathaya Valley2.0`.
- Sintaxis, codificación UTF-8 y claves duplicadas de todos los JSON.
- Mojibake en traducciones españolas (`Ã`, `Â`, `â`, `ð`, `�`).
- La clave crítica `UI_servers_refresh_timer`, que debe ser `REFRESCAR %1`.
- Solapamientos entre `ECZ_Idioma` y `ECZ_Mods`.
- Copias `.bak`, `.backup` o `.disabled` distribuidas dentro de `Contents`.
- Entidades duplicadas y sobrescrituras de archivos globales sensibles.

Las sobrescrituras normales de recursos entre mods no se notifican para evitar miles de falsos positivos.

## Ejecución local

Desde la raíz del repositorio:

```bash
python MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/auditar_modpack_v2.py
```

El proceso genera:

```text
MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/resultado_auditoria.json
MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/resultado_auditoria.md
```

## Reparaciones aplicadas

`REPARACIONES_APLICADAS.md` enumera los cambios efectuados sobre la rama de auditoría. El script `reparar_modpack.py` se conserva como registro reproducible, pero ya no se ejecuta automáticamente.

## GitHub Actions

El flujo `.github/workflows/auditoria-modpack.yml` ejecuta el auditor enfocado cuando cambia el modpack y adjunta los informes como artefacto `auditoria-modpack`.

## Regla del menú multijugador

`ECZ_Idioma` debe estar:

1. Al final de `Mods=`, después de `ECZ_Mods`.
2. Activado localmente desde el menú principal de cada cliente.

La pantalla multijugador se abre antes de recibir la lista de mods del servidor. Por eso la corrección de `UI_servers_refresh_timer` no se aplica al menú cuando `ECZ_Idioma` no está activado localmente.
