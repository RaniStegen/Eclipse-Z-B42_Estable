# Parte 3 terminada — conflictos globales y preparación de runtime

Revisión realizada sobre el contenido activo de `MODPACK-ACTUAL-EN-SERVIDOR` para Project Zomboid Build **42.20.0**.

## Resultado efectivo

- **0 errores estáticos no resueltos**.
- **1 advertencia de mantenimiento**: `ECZChat` reemplaza `ISChat.lua` completo.
- **187 conflictos brutos resueltos** mediante parches tardíos en `ECZ2_Ajustes`.
- **166 objetos** con `EvolvedRecipe` o `Tags` fusionados sin perder aportaciones de los mods de origen.
- **0 conflictos** de ruta → GUID.
- **0 conflictos** de GUID → ruta.
- **0 GUID de outfit** compartidos por outfits distintos.
- **0 nombres o GUID de outfit repetidos dentro del mismo género**.
- **75 parejas hombre/mujer legítimas** reconocidas correctamente.

## Archivos globales

Los formatos globales de Project Zomboid se han analizado como contribuciones acumulativas:

- `media/sandbox-options.txt`
- `media/registries.lua`
- `media/fileGuidTable.xml`
- `media/clothing/clothing.xml`

No se encontraron opciones de sandbox incompatibles ni IDs de registro duplicados. Los conflictos demostrados de GUID y outfits fueron corregidos.

## Compatibilidad de recetas y etiquetas

Se añadió:

```text
EclipseZ - 2/Contents/mods/ECZ2_Ajustes/42.18/media/scripts/zz_ECZ_Compat_Recetas_Etiquetas.txt
```

El archivo se carga después de los proveedores y conserva la unión de:

- 165 conflictos de `EvolvedRecipe`;
- 5 conflictos de `Tags`;
- 166 objetos en total;
- módulos `Base`, `SapphCooking` y `VFX`.

## Propiedades no acumulables

Se añadió:

```text
EclipseZ - 2/Contents/mods/ECZ2_Ajustes/42.18/media/scripts/zz_ECZ_Compat_Propiedades_Parte3.txt
```

Resuelve explícitamente:

- `SapphCooking.FryBatter.Icon`;
- `SapphCooking.VegetableBroth.ReplaceOnUse`;
- `SapphCooking.VegetableBroth.HungerChange`;
- `SapphCooking.VegetableBroth.Calories`;
- animaciones primaria y secundaria de `Base.FountainCupWater`;
- `VFX.SlicedPotato.ThirstChange`;
- `AuthenticZClothing.AuthenticGlowstick_Red.ItemType`;
- `StaticModel` de los nueve neumáticos vanilla modificados por `ECZ_16` y `ECZ2_10`.

## GUID de ropa y outfits

Correcciones aplicadas:

- eliminadas seis asociaciones alternativas de ruta → GUID en `ECZ_25`, conservando los GUID con consenso entre los demás módulos;
- separado el GUID compartido por `Trousers_SportKillaLong.xml` y `Tshirt_SportKillaLong.xml`;
- añadida la referencia de la camiseta separada al outfit `AuthenticKilla`;
- asignados GUID deterministas nuevos a outfits distintos que reutilizaban el mismo GUID;
- conservado el mismo GUID cuando se trata únicamente de la variante masculina y femenina del mismo outfit.

El registro completo está en:

```text
MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/CORRECCIONES_GUID_ROPA.json
```

## Herramientas permanentes

- `generar_manifest_despliegue.py`: compara SHA-256 entre GitHub, Workshop, servidor y cliente.
- `validar_logs_runtime.py`: busca mods ausentes, errores de diccionario, traducciones, checksum, versión, Lua y desconexiones.
- `PARTE_3_PRUEBAS_RUNTIME.md`: matriz de pruebas de conexión, destilería, música, vehículos, ropa, mochilas, armas, chat, agricultura y movimiento.
- `finalizar_auditoria_parte3.py`: separa el inventario bruto de los conflictos realmente no resueltos.

## Advertencia restante

`ECZChat` aporta una copia completa de:

```text
media/lua/client/Chat/ISChat.lua
```

Estado auditado:

- 1.277 líneas;
- 36 funciones `ISChat`;
- SHA-256 `3fff95e8d3500d948c4f28cb35d15b944426299dca29864e524ae4a32f332e61`.

No se ha eliminado porque es contenido funcional del chat. Debe compararse con el `ISChat.lua` vanilla exacto después de cada actualización de Project Zomboid y probarse en cliente.

## Validación externa pendiente

La auditoría del repositorio no demuestra por sí sola que PingPerfect y todos los clientes tengan los mismos bytes. La comprobación definitiva requiere:

1. generar un manifiesto del Workshop instalado en el servidor;
2. generar otro en un cliente limpio;
3. compararlos contra `manifest_github.json`;
4. ejecutar `validar_logs_runtime.py` con el arranque completo del servidor y, al menos, dos clientes.

No se ha borrado ninguna partida, chunk, personaje ni entrada de `WorldDictionary`. `Base.IDBFS_LiquidBarrelRack` permanece presente.
