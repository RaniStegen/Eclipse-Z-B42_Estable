# Optimización para Project Zomboid 42.20

La optimización mantiene cada mod como una unidad independiente. No se han
fusionado scripts, configuraciones ni espacios de nombres.

## Resultado

- Objetivo de ejecución: Project Zomboid 42.20.0.
- 22.052 archivos no activos retirados de forma neta.
- 4.757.240.387 bytes (4,431 GiB) eliminados del contenido de ejecución.
- Se conservan exactamente las 75 IDs indicadas en la configuración canónica.
- Los tiles se mantienen exclusivamente en `ECZ_T1` a `ECZ_T6`.
- `ECZ_8.2` se renombra como `ECZ_T1`; `ECZ_8.3`, `ECZ_8.4` y `ECZ_8.5`
  se retiran porque sus recursos ya están conservados en `ECZ_T3`, `ECZ_T2`
  y `ECZ_T4`, respectivamente.
- Todo lo retirado se puede recuperar desde el historial de Git.

## Criterios aplicados

1. Se conserva la capa numérica más reciente compatible con 42.20 de cada mod.
2. Se eliminan copias antiguas que el cargador ya no selecciona.
3. La optimización se realiza dentro de cada mod, salvo los duplicados de tiles
   que el propietario identificó y agrupó expresamente en la serie `ECZ_T`.
4. Se eliminan archivos de trabajo (`.psd`, `.bak` y marcadores de reparación).
5. Se normalizan IDs y dependencias de manifiestos sin alterar el contenido
   funcional propio de cada mod.
6. Las definiciones de tiles incompatibles se adaptan a los límites de 42.20.

Los detalles verificables quedan en
`docs/optimization-prune-report.json` y
`docs/modpack-validation-report.json`.
