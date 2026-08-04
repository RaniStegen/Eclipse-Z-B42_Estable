# Parte 4 — prueba de regresión del lag global en Cathaya

## Objetivo

Confirmar en un servidor real que la carga rápida de chunks alrededor de `7300,12630,0` ya no bloquea el hilo principal ni provoca lag a jugadores situados en otras zonas.

## Preparación obligatoria

1. Detener completamente el servidor.
2. Crear una copia de seguridad íntegra de la carpeta del mundo.
3. Desplegar exactamente la misma versión del modpack en servidor y clientes.
4. Aplicar el procedimiento de `REPARAR_MAP_ZONE_CATHAYA.md`: renombrar únicamente `map_zone.bin` y dejar intactos `map_meta.bin`, personajes, vehículos y chunks.
5. Arrancar el servidor desde cero y conservar el log completo.

## Participantes

- Cliente A: administrador que realiza el recorrido en vehículo.
- Cliente B: jugador situado lejos de Cathaya, preferiblemente dentro de una base con zombis y objetos activos.
- Opcionalmente, Cliente C permanece cerca de la carretera para observar el vehículo y la carga de entidades.

## Recorrido

1. Empezar fuera de los chunks de Cathaya.
2. Conducir primero un vehículo vanilla hacia `7300,12630,0`.
3. Repetir el recorrido con un vehículo de `ECZ2_10`.
4. Cruzar varias veces las coordenadas aproximadas:

```text
7290,12600
7300,12630
7304,12629
7345,12657
```

5. Detenerse, bajarse, volver a entrar y alejarse a velocidad elevada para forzar descarga y recarga de chunks.
6. Mientras tanto, el Cliente B debe caminar, abrir contenedores, combatir y usar el chat para detectar una pausa global.

## Construcciones de Neat Building

En la misma sesión debe comprobarse:

- suelo de madera de nivel 2 y 3;
- suelo de arena y grava;
- ventana de madera;
- portón doble de alambre;
- `Commercial_GridGlassBlackWall`.

Las construcciones antiguas deben seguir presentes. Construir una unidad nueva de cada tipo confirma que los callbacks continúan disponibles.

## Framework de armas

Equipar un arma que utilice el framework compartido por `ECZ_7.1` y `ECZ_18.2` y probar:

- recarga;
- cambio de modo de fuego;
- accesorio y bayoneta, cuando proceda;
- observación desde un segundo cliente.

El resultado no debe duplicar animaciones, props ni mensajes de sincronización.

## Patrones que deben desaparecer

```text
Zone 171 not found in ZONE_MAP
Invalid SpriteConfig object! scripted object = Wooden_Windows
Invalid SpriteConfig object! scripted object = WoodFloorLvl2
Invalid SpriteConfig object! scripted object = WoodFloorLvl3
Invalid SpriteConfig object! scripted object = SandFloor
Invalid SpriteConfig object! scripted object = GravelFloor
Invalid SpriteConfig object! scripted object = DoubleWireGate
```

`Commercial_GridGlassBlackWall` tampoco debería aparecer. Cuando sea el único aviso restante, revisar específicamente su receta y callback sin volver a introducir las entidades vanilla antiguas.

## Patrones que no invalidan por sí solos la prueba

Estos mensajes pueden proceder de problemas conocidos de Build 42 y deben contarse, pero no equivalen automáticamente al lag global investigado:

```text
AnimState not found: turning180
ItemPickInfo -> cannot get ID for container: inventorymale
ItemPickInfo -> cannot get ID for container: inventoryfemale
moveZombie: There are no zombies in nz.zombies
```

La prueba falla cuando aparecen en una ráfaga acompañada de una pausa medible o de una excepción, no por una línea aislada.

## Resultado esperado

- Ningún parón global perceptible para el Cliente B.
- Sin búsquedas de la zona 171.
- Sin ráfagas de `SpriteConfig` al cargar los chunks.
- Vehículos y zombis sincronizados.
- Construcciones antiguas y nuevas operativas.
- Una sola ejecución funcional del framework de armas.
