# Corrección de equipamiento, buscador de objetos y escaleras — 2026-08-04

## Build objetivo

Project Zomboid **42.20.0**.

## 1. Relojes y riñoneras no se equipaban

### Síntoma

La acción «Ponerse» completaba la animación y la barra de progreso, pero el objeto permanecía en el inventario sin equiparse. Se reproducía con objetos vanilla.

### Causa

`ECZ_25` ejecutaba `BodyLocations.reset()` durante `OnGameBoot` y reconstruía todos los grupos corporales. En Build 42.20 esto podía invalidar la instancia activa del grupo `Human` y eliminar o desacoplar ranuras registradas por vanilla y otros mods.

### Corrección

`AuthenticZ_BodyLocations.lua` ya no reinicia ni reconstruye `BodyLocations`.

Ahora:

- obtiene el grupo `Human` existente;
- añade únicamente las siete ranuras de AuthenticZ;
- conserva todas las ranuras vanilla y de terceros;
- mantiene el orden visual relativo cuando la API lo permite;
- no sustituye el grupo activo del personaje.

## 2. Error al generar objetos desde el buscador

### Síntoma

Cada objeto creado desde el buscador generaba una excepción en el chat.

### Causa confirmada por el registro

`ECZChat_Config.lua` utilizaba un `string.gsub` con dos capturas y una función de reemplazo. Kahlua entregaba `nil` como segundo argumento y el código intentaba concatenarlo con `"'s inventory."`.

### Corrección

El mensaje se analiza primero con `string.match` y después se recompone sin callback multicaptura. Se convierten a texto todos los valores antes de concatenarlos y se conservan posibles prefijos o sufijos del mensaje.

## 3. Escaleras concisas y movimiento de todas las escaleras

### Síntomas tras el primer parche

- el rellano superior aparecía al lado de la escalera;
- la subida avanzaba por saltos visibles;
- el comportamiento se extendía a otras escaleras.

### Causa

El parche anterior modificaba con `IsoSprite:setType()` doce sprites del tileset global `fixtures_stairs_01` durante varios eventos y al cargar cada cuadrícula. Esos sprites no pertenecen exclusivamente a la receta concisa, por lo que el cambio afectaba a cualquier escalera que los utilizase.

Además, el orden de los tres sprites se interpretó como superior/central/inferior cuando `SpriteConfig` los construye de inferior a superior. El tramo inferior quedó marcado como superior y el callback vanilla generó el rellano desde la casilla equivocada.

### Corrección

El parche global se ha retirado.

La compatibilidad actual:

- no modifica ninguna definición compartida de `IsoSprite`;
- no registra eventos globales;
- no recorre cuadrículas cargadas;
- solo asigna el tipo al objeto conciso que acaba de construirse;
- usa el orden correcto inferior/central/superior;
- delega la finalización y el rellano en `BuildRecipeCode.stairs.OnCreate`.

## Prueba dentro del juego

Tras sustituir los archivos, servidor y clientes deben cerrarse completamente y usar exactamente la misma versión.

Comprobar:

1. equipar un reloj vanilla en ambas muñecas;
2. equipar una riñonera vanilla delante y detrás;
3. generar varios objetos desde el buscador y verificar que no aparece una excepción;
4. construir escaleras vanilla de madera y metal;
5. construir las escaleras concisas de madera y metal en las dos orientaciones;
6. comprobar una subida continua y que el rellano aparece frente al tramo superior.

No se modifican partidas, personajes, chunks ni `WorldDictionary`.
