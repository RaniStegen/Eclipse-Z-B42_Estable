# Eclipse-Z — Build 42.20 estable

Modpack privado de servidor preparado para **Project Zomboid 42.20.0** y
localizado íntegramente al español de España.

## Organización

Los mods siguen siendo independientes. Cada uno conserva su propio ID,
manifiesto, scripts y recursos. La optimización no crea un mod monolítico.

- `EclipseZ - 1`: primer bloque de mods.
- `EclipseZ - 2`: segundo bloque y ajustes del servidor.
- `EclipseZ - 3`: bibliotecas y extensiones complementarias.
- `ECZTraducciones`: localización base y memoria de traducción de los mods.

La configuración auditada activa 80 IDs. El repositorio contiene 81 IDs
válidos; `ECZ_T1` queda disponible como alias opcional.

## Localización

- `ECZ_Idioma`: reconstrucción de la localización base sobre la estructura
  actual de la Build 42.20.
- `ECZ_Mods`: traducciones de todos los mods activos.

La revisión conserva variables, etiquetas, saltos de línea y demás marcadores
técnicos. Los nombres propios, identificadores y títulos que deben permanecer
sin traducir se mantienen deliberadamente.

Resultados de la auditoría:

- 20.354 claves inglesas activas revisadas.
- 42.455 entradas españolas centrales.
- 0 claves activas ausentes.
- 0 marcadores técnicos incompatibles.
- 0 candidatos de texto inglés pendientes.

## Optimización

Se han retirado 21.898 archivos que no participan en la ejecución de 42.20:
capas antiguas, recursos idénticos duplicados y artefactos de desarrollo. La
reducción es de 4,428 GiB. Todo permanece recuperable desde Git.

Los paquetes de tiles equivalentes conservan sus IDs mediante alias ligeros:

| ID alternativo | Contenido canónico |
| --- | --- |
| `ECZ_T1` | `ECZ_8.2` |
| `ECZ_T2` | `ECZ_8.4` |
| `ECZ_8.3` | `ECZ_T3` |
| `ECZ_8.5` | `ECZ_T4` |

## Validación

La validación final confirmó:

- 81 manifiestos activos y 81 IDs únicos.
- Todas las dependencias, paquetes y definiciones de tiles resueltas.
- 1.200 archivos JSON válidos.
- 0 capas de versión obsoletas.
- Arranque completo del servidor con los 80 mods configurados.
- 0 mods ausentes y 0 objetos de script desconocidos.

Los informes detallados están disponibles en [`docs`](docs).
