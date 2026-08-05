# Parte 4 — diagnóstico y corrección del lag global

Revisión realizada sobre los registros del servidor y el contenido activo del modpack para Project Zomboid Build **42.20.0**.

## Conclusión

El coche fue el **detonante**, no la causa única. Al desplazarse rápidamente, obligó al servidor a cargar chunks nuevos de `Cathaya Valley2.0`. En esa carga coincidieron dos problemas:

1. `ECZ3_3` — Neat Building estaba sustituyendo entidades vanilla de Build 42.20 por definiciones antiguas de su carpeta `42.15`. La validación de objetos produjo cientos de avisos `Invalid SpriteConfig` en ráfagas de menos de un segundo.
2. El mundo guardado conserva un `map_zone.bin` generado con una versión anterior de Cathaya. El mapa actual tiene 127 objetos de zona, pero el servidor intenta resolver la zona 171.

Ambos trabajos se realizan en el hilo principal del servidor. Por eso el parón se vuelve global y afecta también a jugadores alejados del vehículo.

## Evidencia del registro

Los dos extractos contienen, contando todas las líneas aportadas:

- 210 avisos `Invalid SpriteConfig`;
- 72 avisos `AnimState not found: turning180`;
- 38 consultas a contenedores `inventorymale` o `inventoryfemale` inexistentes;
- 32 búsquedas de `Zone 171 not found in ZONE_MAP`;
- 22 mensajes `moveZombie: There are no zombies in nz.zombies`;
- 5 paquetes recibidos con `connection is null`.

La ráfaga más grave agrupa aproximadamente 156 avisos de `SpriteConfig` alrededor de `st:123,484`, en solo unos milisegundos. Los objetos repetidos son:

- `WoodFloorLvl2`;
- `Wooden_Windows`;
- `SandFloor`;
- `GravelFloor`;
- `Commercial_GridGlassBlackWall`;
- `DoubleWireGate`;
- `WoodFloorLvl3`.

Todos pertenecen a definiciones incluidas por `ECZ3_3`.

## Correcciones aplicadas

### Neat Building — `ECZ3_3`

Se han retirado de la capa `42.15` las seis redefiniciones antiguas de entidades vanilla:

```text
entity_wood_windowglass.txt
entity_wood_floorlvl2.txt
entity_wood_floorlvl3.txt
entity_floor_sand.txt
entity_floor_gravel.txt
entity_metal_doublewiregate.txt
```

Build 42.20 vuelve a utilizar sus definiciones vanilla actuales. No se eliminan sprites, recetas ni objetos guardados: los identificadores de entidad permanecen y las construcciones existentes deben resolver contra la versión actual.

También se añadió:

```text
ECZ3_3/common/media/lua/shared/Neat_Building/Patch/NB_BuildRecipeCode_CallbackStubs.lua
```

Garantiza que los callbacks de las entidades personalizadas puedan resolverse durante la validación de `SpriteConfig` tanto en cliente como en servidor. Las implementaciones reales del servidor siguen siendo autoritativas.

### Cathaya — `ECZ_8`

La auditoría del `objects.lua` actual confirma:

- 127 objetos de zona;
- zona 171 inexistente;
- las coordenadas `7301–7304,12626–12629` están dentro del mapa;
- el objeto que cubre esas coordenadas es una zona `DeepForest`.

La rama incluye `REPARAR_MAP_ZONE_CATHAYA.md`. La operación necesaria en producción es regenerar **solo** `map_zone.bin` tras realizar una copia de seguridad. No se debe tocar `map_meta.bin`, `players.db`, `vehicles.db`, chunks ni población zombi.

### Framework de armas duplicado

`ECZ_7.1` y `ECZ_18.2` contenían:

- 98 archivos activos cada uno;
- 98 archivos idénticos por ruta y SHA-256;
- 62 archivos Lua idénticos;
- ninguna diferencia ni archivo exclusivo.

Se conserva `ECZ_7.1` como proveedor. `ECZ_18.2` mantiene su ID para no romper dependencias, pero Build 42.20 selecciona una capa vacía que declara:

```text
require=ECZ_7.1
loadModAfter=ECZ_7.1
```

Así solo se registra una copia de sus siete `OnTick`, cuatro `OnPlayerUpdate` y comandos de red.

### Modelos duplicados

`ECZ2_Ajustes` contenía una copia exacta de todas las animaciones/modelos de `ECZ2_18`:

- 402 archivos;
- 230.671.000 bytes;
- misma ruta y mismo SHA-256 en todos los casos;
- 0 archivos diferentes u omitidos.

Se han retirado únicamente de `ECZ2_Ajustes`. Los recursos siguen disponibles desde `ECZ2_18`, que se carga antes. El registro verificable está en:

```text
_AUDITORIA/MODELOS_DUPLICADOS_ELIMINADOS.json
```

## Qué arreglaban las revisiones anteriores

Las correcciones anteriores de traducciones, recetas, GUID y ropa no solucionaban este parón concreto. El parche de nueve neumáticos evitaba un conflicto de `StaticModel` entre `ECZ_16` y `ECZ2_10`, pero no corregía el índice de Cathaya ni las entidades de Neat Building.

## Ranking estático de carga

La puntuación prioriza revisión por número de eventos, bucles, llamadas de red, líneas Lua activas y tamaño de recursos. No sustituye un perfilador real de CPU o heap.

### CPU del servidor

1. `ECZ_15` — Extensive Health: riesgo muy alto; 17 `OnTick`, cuatro `OnPlayerUpdate` y un conjunto Lua muy grande.
2. `ECZ_4` — Lifestyle: riesgo muy alto; mucha lógica compartida, audio/actividades y el mayor número de referencias de sincronización.
3. `ECZ_7.1` — framework de armas: riesgo alto; ahora se carga una sola vez.
4. `ECZ2_16` — Extensive Power: riesgo alto; red eléctrica de edificios, apagones y comprobaciones periódicas.
5. `ECZ_2` — laboratorio/vacuna: riesgo medio-alto.
6. `ECZ2_10` — vehículos: riesgo medio-alto y especialmente sensible cuando varios jugadores conducen y sincronizan vehículos.
7. `ECZ_3` — Jaxe Revival: riesgo medio por estados de incapacitación, jugador y zombi.
8. `ECZ_6.1` — Starlit Library: riesgo medio como framework compartido.
9. `ECZ_24`, `ECZ_19`, `ECZ_25`, `ECZ_23` y `ECZ_10`: riesgo medio según funciones activas.

`ECZ3_3` no era de los mayores consumidores continuos, pero sí generaba la mayor **carga explosiva al cargar chunks**, que es el patrón observado en el incidente.

### Mod de zonas por tier — `ECZ_26.1`

- puesto aproximado 18 en riesgo estático de CPU de servidor;
- puesto 7 en CPU de cliente;
- 16 líneas Lua exclusivas de servidor y 953 compartidas;
- un `OnPlayerMove`, un `OnPlayerUpdate`, comprobaciones periódicas y lógica al atacar;
- 11 referencias de sincronización;
- presión de RAM y assets prácticamente nula.

Es una carga **moderada en cliente y baja/moderada en servidor**. No genera `ZONE_MAP`: ese mensaje pertenece al índice del mapa guardado. Tampoco explica la ráfaga de `SpriteConfig`.

### RAM, descarga y recursos de cliente

Los mayores paquetes activos son:

1. `ECZ2_18` — poses/animaciones TTRP: unos 230,7 MB de animaciones; ya no existe la copia adicional en `ECZ2_Ajustes`.
2. `ECZ_4` — Lifestyle: aproximadamente 172 MB de modelos y 71 MB de texturas.
3. `ECZ_T2` — paquete de tiles/texturas: aproximadamente 341 MB de texturas.
4. `ECZ_25` — Authentic Z: aproximadamente 166 MB de texturas y 48 MB de modelos.
5. `ECZ2_10` — vehículos: aproximadamente 20 MB de texturas y 44 MB de modelos.
6. `ECZ_20`, `ECZ_15`, `ECZ2_11`, `ECZ_5` y `ECZ_1`: siguientes por volumen de assets.

Estos tamaños afectan sobre todo a descarga, verificación, almacenamiento y memoria del cliente. En el servidor, la presión real depende más de chunks activos, número de zombis, vehículos, animales, objetos y tablas Lua que de las texturas.

## Validación

La auditoría completa de la rama y la limpieza idempotente de duplicados terminan correctamente en GitHub Actions después de aplicar las correcciones. Esto confirma la coherencia estática, las dependencias, los hashes y la ausencia de los duplicados detectados, pero **no demuestra todavía el comportamiento real del servidor**.

Sigue pendiente desplegar en producción, regenerar `map_zone.bin` y ejecutar `PARTE_4_PRUEBA_LAG_CATHAYA.md` con dos clientes.

El resultado se considerará confirmado cuando:

- desaparezca `Zone 171 not found in ZONE_MAP`;
- no haya ráfagas `Invalid SpriteConfig` al conducir por `7300,12630,0`;
- el jugador situado lejos no sufra una pausa global;
- las construcciones antiguas y nuevas de Neat Building funcionen;
- armas y vehículos sigan sincronizando correctamente.
