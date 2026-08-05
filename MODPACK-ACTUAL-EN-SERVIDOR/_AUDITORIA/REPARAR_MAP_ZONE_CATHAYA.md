# Reparación segura de `map_zone.bin` — Cathaya Valley

## Diagnóstico confirmado

El `objects.lua` actualmente distribuido por `ECZ_8` contiene **127 objetos de zona**. El servidor, sin embargo, repite:

```text
Zone 171 not found in ZONE_MAP
```

Las coordenadas del registro (`7301–7304, 12626–12629`) pertenecen a `Cathaya Valley2.0`. El mundo guardado conserva por tanto un índice de zonas generado con una versión anterior del mapa.

## Qué se debe regenerar

Solo:

```text
map_zone.bin
```

No tocar:

```text
players.db
vehicles.db
map_meta.bin
map_t.bin
map_*.bin
chunkdata_*.bin
datachunk_*.bin
zpop_*.bin
```

`map_meta.bin` puede contener casas seguras y otros metadatos. No forma parte de esta reparación.

## Procedimiento en el servidor

1. Detener completamente el servidor y comprobar que el proceso Java ha terminado.
2. Crear una copia completa de la carpeta del mundo.
3. Dentro de la carpeta activa del mundo, renombrar:

```text
map_zone.bin
```

como:

```text
map_zone.bin.antes-reparacion-cathaya
```

4. Iniciar el servidor. Project Zomboid regenerará el índice de zonas a partir del `objects.lua` actualmente instalado.
5. Entrar primero con un administrador y recorrer Cathaya, especialmente las coordenadas aproximadas `7300,12630,0`.
6. Confirmar que ya no aparece `Zone 171 not found in ZONE_MAP`.

## Clientes

Normalmente el servidor vuelve a suministrar la información regenerada. Cuando un cliente concreto siga mostrando errores de descarga o zonas antiguas, con el juego cerrado debe renombrar únicamente el archivo local:

```text
%USERPROFILE%\Zomboid\Saves\Multiplayer\<servidor_usuario>\map_zone.bin
```

No debe eliminar `map_p.bin`, porque contiene datos locales del personaje en versiones antiguas del formato.

## Efectos esperados

- No elimina personajes.
- No elimina inventarios.
- No elimina vehículos.
- No regenera edificios ni loot de los chunks.
- Puede reinicializar información derivada de zonas, como datos de forrajeo asociados a ellas.

## Vuelta atrás

Con el servidor detenido, borrar el `map_zone.bin` recién generado y devolver al nombre original la copia:

```text
map_zone.bin.antes-reparacion-cathaya
```
