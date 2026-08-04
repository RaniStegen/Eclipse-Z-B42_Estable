# Parte 2 completada — mod.info, dependencias y versiones

Revisión realizada contra Project Zomboid Build **42.20.0** y contra la línea `Mods=` de referencia del servidor.

## Cobertura

- 78 entradas de `Mods=` comparadas.
- 5 paquetes Workshop presentes revisados.
- 76 carpetas de mods revisadas.
- 92 archivos `mod.info` analizados.
- 80 carpetas numéricas de versión comprobadas.
- 76 IDs activos detectados.

## Correcciones aplicadas

1. `ECZ_T1` se ha movido antes de `ECZ_8` en la línea de referencia. `ECZ_8` declara tanto `require=ECZ_T1` como `loadModAfter=ECZ_T1`, por lo que la dependencia debe cargarse primero.
2. Corregido `poster=poster.pnmg` por `poster=poster.png` en `ECZ2_5`.
3. La auditoría acepta correctamente `pack=`, `tiledef=`, `require=` y los campos de orden como claves multivalor válidas; no se ha eliminado ninguna declaración de tiles o packs.
4. La estructura de `ECZ_9`, con metadata en `common/mod.info` y contenido versionado en `42.0`, se considera válida para la arquitectura versionada de Build 42.
5. Se han validado IDs, nombres, dependencias, capitalización, orden, versiones compatibles, versiones futuras, assets declarados y duplicados entre carpetas.

## Resultado final

- **0 errores** en los 76 mods presentes.
- **0 advertencias** en los 76 mods presentes.
- La línea de carga ya respeta todas las dependencias detectadas.
- `ECZ_Mods;ECZ_Idioma` permanece como final protegido.

Quedan fuera de la validación únicamente dos IDs incluidos en el servidor pero no subidos al repositorio:

- `NewMusic`
- `eclipsemusic`

No pueden revisarse sus `mod.info`, dependencias ni carpetas de versión hasta que sus paquetes completos estén dentro de `MODPACK-ACTUAL-EN-SERVIDOR`.

## Línea Mods= corregida

```ini
Mods=ECZ_1;ECZ_2;ECZ_3;ECZ_4;ECZ_5;ECZ_6.1;ECZ_6.2;ECZ_7.1;ECZ_T1;ECZ_8;ECZ_9;ECZ_10;ECZ_11;ECZ_12;ECZ_13.1;ECZ_13.2;ECZ_14;ECZ_15;ECZ_16;ECZ_17;ECZ_18.1;ECZ_18.2;ECZ_18.3;ECZ_18.4;ECZ_19;ECZ_20;ECZ_21.1;ECZ_21.2;ECZ_22;ECZ_23;ECZ_24;ECZ_25;ECZ_26.1;ECZ_26.2;ECZ_26.3;ECZ_26.4;ECZ_26.5;ECZ_T2;ECZ_T3;ECZ_T4;ECZ_T5;ECZ_T6;ECZ2_1;ECZ2_2.1;ECZ2_2.2;ECZ2_3;ECZ2_4;ECZ2_5;ECZ2_6;ECZ2_7.1;ECZ2_7.2;ECZ2_7.3;ECZ2_8.1;ECZ2_8.2;ECZ2_9;ECZ2_10;ECZ2_11;ECZ2_12;ECZ2_13;ECZ2_14;ECZ2_16;ECZ2_17;ECZ2_18;ECZ2_Ajustes;ECZ3_1;ECZ3_2;ECZ3_3;ECZ3_4;ECZ3_5.1;ECZ3_5.2;ECZ3_6;ECZ3_7;ECZ3_8;ECZChat;NewMusic;eclipsemusic;ECZ_Mods;ECZ_Idioma
```
