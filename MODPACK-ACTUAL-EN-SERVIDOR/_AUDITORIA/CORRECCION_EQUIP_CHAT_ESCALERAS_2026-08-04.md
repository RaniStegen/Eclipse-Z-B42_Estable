# Corrección de equipamiento, buscador de objetos y escaleras — 4 de agosto de 2026

## Estado

La primera corrección de relojes/riñoneras y la segunda revisión de la escalera concisa resultaron incompletas durante la prueba real. Este documento describe la revisión v3 actualmente aplicada en la rama.

## 1. Relojes y riñoneras

### Diagnóstico final

`ISWearClothing.complete()` no estaba sustituido por ningún mod activo: el único hook directo localizado modifica `start()` para el sombrero neural de Lifestyle y no afecta a muñecas ni riñoneras.

El problema restante estaba en la manipulación del grupo corporal `Human`:

- AuthenticZ había dejado de ejecutar `BodyLocations.reset()`, pero todavía reordenaba ranuras mediante `moveLocationToIndex`.
- Spongie Open Jackets también reordenaba el grupo desde `BodyLocations_Helper.lua`.
- Glasses With Gas Masks movía sus dos ranuras personalizadas junto a las posiciones vanilla.

Build 42.20 declara las localizaciones en orden de renderizado desde `BodyLocations.lua`; cambiar los índices del grupo vivo después de inicializar `WornItems` puede dejar desacopladas posiciones como muñecas y riñoneras.

### Corrección v3

- Eliminado todo uso activo de `BodyLocations.reset()`.
- Eliminado todo uso activo de `moveLocationToIndex` en los tres proveedores afectados.
- Los mods añaden exclusivamente sus ranuras personalizadas mediante `getOrCreateLocation`.
- Añadido un parche tardío en `ECZ2_Ajustes` que garantiza, tanto en el grupo global como en el grupo corporal real del personaje:
  - `ItemBodyLocation.LEFT_WRIST`;
  - `ItemBodyLocation.RIGHT_WRIST`;
  - `ItemBodyLocation.FANNY_PACK_FRONT`;
  - `ItemBodyLocation.FANNY_PACK_BACK`.
- `ISWearClothing.complete()` sigue siendo la implementación vanilla. El parche solo prepara esas cuatro ranuras antes de la llamada y repite el mismo `setWornItem` cuando la operación vanilla termina sin dejar el objeto equipado.

Archivo añadido:

```text
EclipseZ - 2/Contents/mods/ECZ2_Ajustes/42.18/media/lua/shared/NPCs/zz_ECZ_BodyLocations_B42_20.lua
```

## 2. Buscador de objetos

El error procedía de `ECZChat_Config.lua`: el callback de `string.gsub` esperaba dos capturas al traducir el mensaje `Item ... Added in ...'s inventory.`, pero Kahlua podía entregar `nil` para el usuario y provocar `__concat not defined`.

El mensaje se analiza ahora con `string.match` y se recompone sin callback multicaptura.

## 3. Escaleras de madera concisas

### Diagnóstico final

La segunda revisión invirtió el orden de los tres sprites. Los archivos de escaleras funcionales y el callback vanilla demuestran que cada fila está declarada como:

1. tramo superior;
2. tramo central;
3. tramo inferior.

Por tanto, la escalera de madera concisa debe usar:

```text
82 = stairsTN
81 = stairsMN
80 = stairsBN

90 = stairsTW
89 = stairsMW
88 = stairsBW
```

La versión invertida identificaba el tramo inferior como superior, por lo que solo este modelo volvía a fallar.

### Corrección v3

- Restaurado el orden superior/central/inferior.
- `OnCreate` cambia únicamente el tipo de la instancia recién construida.
- `OnIsValid` entrega temporalmente al callback vanilla el tipo correcto del sprite y restaura inmediatamente el tipo original.
- No existen cambios globales persistentes, eventos `LoadGridsquare` ni barridos de chunks.
- Las demás escaleras conservan su comportamiento vanilla.

Las escaleras concisas construidas con versiones anteriores pueden conservar objetos o rellanos erróneos guardados en la partida; deben retirarse y reconstruirse una vez tras actualizar.

## Validación

La auditoría estática completa del modpack terminó correctamente sobre el commit funcional de esta revisión. También se verificó específicamente:

- ausencia de `BodyLocations.reset()` activo;
- ausencia de `moveLocationToIndex` en los tres proveedores corregidos;
- ausencia de `LoadGridsquare` y de mutación persistente de sprites en la escalera;
- orden correcto de los seis sprites de madera y los seis metálicos;
- conservación del callback vanilla como autoridad.

La validación interactiva final requiere servidor y cliente reales de Project Zomboid 42.20.
