# Optimización para Project Zomboid 42.20

La optimización mantiene cada mod como una unidad independiente. No se han
fusionado scripts, configuraciones ni espacios de nombres.

## Resultado

- Objetivo de ejecución: Project Zomboid 42.20.0.
- 21.400 archivos no activos retirados de forma neta.
- 3.213.866.141 bytes (2,993 GiB) eliminados del contenido de ejecución.
- Se conservan exactamente las 78 IDs indicadas en la configuración canónica.
- `ECZ_T2`, `ECZ_8.3` y `ECZ_8.5` mantienen sus propios recursos y no son
  alias de otros mods.
- Todo lo retirado se puede recuperar desde el historial de Git.

## Criterios aplicados

1. Se conserva la capa numérica más reciente compatible con 42.20 de cada mod.
2. Se eliminan copias antiguas que el cargador ya no selecciona.
3. La optimización se realiza dentro de cada mod; no se eliminan recursos por
   estar repetidos en otro ID.
4. Se eliminan archivos de trabajo (`.psd`, `.bak` y marcadores de reparación).
5. Se normalizan IDs y dependencias de manifiestos sin alterar el contenido
   funcional propio de cada mod.
6. Las definiciones de tiles incompatibles se adaptan a los límites de 42.20.

Los detalles verificables quedan en
`docs/optimization-prune-report.json` y
`docs/modpack-validation-report.json`.
