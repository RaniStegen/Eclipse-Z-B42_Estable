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

La configuración canónica activa exactamente 75 IDs. El repositorio contiene
esas mismas 75 IDs y las cuatro publicaciones de Workshop indicadas en
[`config/Server-42.20-IDs.ini`](config/Server-42.20-IDs.ini).

## Localización

- `ECZ_Idioma`: reconstrucción de la localización base sobre la estructura
  actual de la Build 42.20.
- `ECZ_Mods`: traducciones de todos los mods activos.

La revisión conserva variables, etiquetas, saltos de línea y demás marcadores
técnicos. Los nombres propios, identificadores y títulos que deben permanecer
sin traducir se mantienen deliberadamente.

Resultados de la auditoría:

- 20.287 claves inglesas activas revisadas.
- 42.455 entradas españolas centrales.
- 0 claves activas ausentes.
- 0 marcadores técnicos incompatibles.
- 0 candidatos de texto inglés pendientes.

## Optimización

Se han retirado de forma neta 22.052 archivos que no participan en la
ejecución de 42.20: capas antiguas, IDs no solicitadas y artefactos de
desarrollo. La reducción neta es de 4,431 GiB. Todo permanece recuperable
desde Git.

Los paquetes de tiles están organizados exclusivamente como `ECZ_T1` a
`ECZ_T6`. `ECZ_8.2` se renombró como `ECZ_T1`; los recursos que estaban
duplicados en `ECZ_8.3`, `ECZ_8.4` y `ECZ_8.5` permanecen en `ECZ_T3`,
`ECZ_T2` y `ECZ_T4`, respectivamente. El paquete de Melos de `ECZ_T3` está
adaptado al límite de tilesets de Build 42.20.

## Validación

La validación final confirmó:

- 75 manifiestos activos y 75 IDs únicos.
- Las 75 IDs coinciden exactamente con la configuración canónica.
- Las 4 Workshop ID coinciden exactamente con sus publicaciones.
- Todas las dependencias, paquetes y definiciones de tiles resueltas.
- 1.200 archivos JSON válidos.
- 0 capas de versión obsoletas.
- Arranque completo del servidor con los 75 mods configurados.
- 0 mods ausentes, 0 objetos de script desconocidos y 0 definiciones de tiles
  inválidas.

Los informes detallados están disponibles en [`docs`](docs).
