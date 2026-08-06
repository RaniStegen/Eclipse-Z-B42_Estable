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

La configuración canónica activa exactamente 78 IDs. El repositorio contiene
esas mismas 78 IDs y las cuatro publicaciones de Workshop indicadas en
[`config/Server-42.20-IDs.ini`](config/Server-42.20-IDs.ini).

La familia de armas `ECZ_18` está organizada en cuatro módulos independientes y
se carga en el orden exigido por sus autores: `ECZ_18.1` (Hot Brass),
`ECZ_18.2` (Gunworks), `ECZ_18.3` (Guns of Marz) y `ECZ_18.4`
(Black Powder Gunsmithing). `ECZ_27` contiene Offline Survivor para servidores
multijugador. La procedencia y los IDs originales están documentados en
[`docs/ecz-18-guns-of-marz.json`](docs/ecz-18-guns-of-marz.json).

`ECZ_8` contiene Cathaya Valley 2.0 y carga su requisito `ECZ_T7`
(CommunityTilePack) antes del mapa. El orden de mapas del servidor es
`Cathaya Valley2.0;Muldraugh, KY`.

## Localización

- `ECZ_Idioma`: reconstrucción de la localización base sobre la estructura
  actual de la Build 42.20.
- `ECZ_Mods`: traducciones de todos los mods activos.

La revisión conserva variables, etiquetas, saltos de línea y demás marcadores
técnicos. Los nombres propios, identificadores y títulos que deben permanecer
sin traducir se mantienen deliberadamente.

Resultados de la auditoría:

- 20.643 claves inglesas activas revisadas.
- 43.107 entradas españolas centrales.
- 0 claves activas ausentes.
- 0 marcadores técnicos incompatibles.
- 0 candidatos de texto inglés pendientes.

## Optimización

Se han retirado de forma neta 21.230 archivos que no participan en la
ejecución de 42.20: capas antiguas, IDs no solicitadas y artefactos de
desarrollo. La reducción neta es de 4,314 GiB. Todo permanece recuperable
desde Git.

Los paquetes de tiles están organizados exclusivamente como `ECZ_T1` a
`ECZ_T7`. `ECZ_8.2` se renombró como `ECZ_T1`; los recursos que estaban
duplicados en `ECZ_8.3`, `ECZ_8.4` y `ECZ_8.5` permanecen en `ECZ_T3`,
`ECZ_T2` y `ECZ_T4`, respectivamente. El paquete de Melos de `ECZ_T3` está
adaptado al límite de tilesets de Build 42.20.

## Validación

La validación final confirmó:

- 78 manifiestos activos y 78 IDs únicos.
- Las 78 IDs coinciden exactamente con la configuración canónica.
- Las 4 Workshop ID coinciden exactamente con sus publicaciones.
- Todas las dependencias, paquetes y definiciones de tiles resueltas.
- 1.217 archivos JSON válidos.
- 0 capas de versión obsoletas.
- Arranque completo del servidor con los 78 mods configurados.
- 0 mods ausentes, 0 objetos de script desconocidos y 0 definiciones de tiles
  inválidas.

Los informes detallados están disponibles en [`docs`](docs).
