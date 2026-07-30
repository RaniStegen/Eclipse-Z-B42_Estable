# Optimización para Project Zomboid 42.20

La optimización mantiene cada mod como una unidad independiente. No se han
fusionado scripts, configuraciones ni espacios de nombres.

## Resultado

- Objetivo de ejecución: Project Zomboid 42.20.0.
- 83 directorios históricos y 59 archivos de desarrollo retirados.
- 21.898 archivos no activos retirados.
- 4.754.358.314 bytes (4,428 GiB) eliminados del contenido de ejecución.
- Los IDs alternativos de paquetes de tiles continúan disponibles mediante
  alias ligeros con dependencias explícitas.
- Todo lo retirado se puede recuperar desde el historial de Git.

## Criterios aplicados

1. Se conserva la capa numérica más reciente compatible con 42.20 de cada mod.
2. Se eliminan copias antiguas que el cargador ya no selecciona.
3. Se retiran recursos idénticos duplicados, pero se conserva el ID de cada mod.
4. Se eliminan archivos de trabajo (`.psd`, `.bak` y marcadores de reparación).
5. Se normalizan IDs y dependencias de manifiestos sin alterar el contenido
   funcional propio de cada mod.

Los detalles verificables quedan en
`docs/optimization-prune-report.json` y
`docs/modpack-validation-report.json`.
