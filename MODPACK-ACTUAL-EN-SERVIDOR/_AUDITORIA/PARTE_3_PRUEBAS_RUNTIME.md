# Parte 3 — validación de despliegue y runtime

Esta fase complementa las auditorías estáticas. No modifica partidas ni borra el `WorldDictionary`.

## 1. Manifiestos de despliegue

Generar un manifiesto en cada ubicación usando la misma versión de `generar_manifest_despliegue.py`.

### Fuente de GitHub

```bash
python MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/generar_manifest_despliegue.py \
  MODPACK-ACTUAL-EN-SERVIDOR \
  --output manifest_github.json
```

### Servidor dedicado

Usar como origen el directorio que contiene los Workshop Items descargados:

```bash
python generar_manifest_despliegue.py \
  /ruta/steamapps/workshop/content/108600 \
  --config configuracion_servidor_actual.json \
  --output manifest_servidor.json
```

### Cliente limpio

```bash
python generar_manifest_despliegue.py \
  /ruta/Steam/steamapps/workshop/content/108600 \
  --config configuracion_servidor_actual.json \
  --output manifest_cliente.json
```

### Comparación

```bash
python generar_manifest_despliegue.py \
  --compare manifest_github.json manifest_servidor.json \
  --output comparacion_github_servidor.json

python generar_manifest_despliegue.py \
  --compare manifest_servidor.json manifest_cliente.json \
  --output comparacion_servidor_cliente.json
```

`NewMusic` y `eclipsemusic` se clasifican como externos. Se informa de su presencia, pero sus archivos no se comparan contra el modpack interno.

## 2. Arranque limpio del servidor

1. Detener completamente el servidor.
2. Conservar una copia de seguridad de la partida y configuración.
3. Vaciar únicamente las copias descargadas de los Workshop Items internos que se vayan a reinstalar; no borrar la partida.
4. Forzar la descarga de los Workshop Items.
5. Iniciar el servidor y guardar el log completo desde el principio.
6. Confirmar que aparecen las 76 cargas internas y que no aparece `required mod ... not found`.
7. Confirmar que `ECZ_T1` se carga antes de `ECZ_8`.
8. Confirmar que el final lógico mantiene `ECZ_Mods` y después `ECZ_Idioma`.

## 3. Preparación de clientes

1. Cerrar Project Zomboid y Steam.
2. Reinstalar los Workshop Items que no coincidan con el manifiesto del servidor.
3. Activar `ECZ_Mods` y `ECZ_Idioma` localmente desde el menú principal.
4. Reiniciar completamente el juego.
5. Abrir Multijugador antes de conectar y comprobar que no aparece `IllegalFormatConversionException`.

## 4. Matriz mínima de pruebas multijugador

| Prueba | Cliente A | Cliente B | Resultado esperado |
|---|---|---|---|
| Conexión inicial | Administrador | Usuario | Ambos alcanzan selección/carga de personaje |
| Reconexión | Sale y vuelve | Permanece | Sin pérdida de inventario ni `WorldDictionaryException` |
| Cambio de planta | Radiocasete activo | Escucha desde otra planta | Audio estable, sin apagado ni fuente fantasma |
| Vehículo | Inserta/retira medio | Observa inventario abierto | Estado y texto sincronizados |
| Prensa | Menú contextual | Menú de elaboración | Mismos nombres y requisitos; receta ejecutable |
| Destilería | Usa objeto ya construido | Observa | Sin recreación de componentes ni pérdida de objetos |
| Ropa | Equipa variantes | Observa modelo | Icono y modelo visibles, sin cuerpo invisible |
| Mochilas | Mejora una mochila | Observa transferencia | Sin pérdida de contenido ni desincronización |
| Armas | Instala silenciador | Escucha disparos | Audio actualizado sin tirar el arma al suelo |
| Chat | Usa `/name` y controles | Recibe mensajes | Interfaz estable y sin volver al chat antiguo |
| Agricultura | Abre estado de cosecha | Observa | Modal cerrable y sin errores por fotograma |
| Movimiento | Camina/gira varios minutos | Observa | Sin caminar hacia atrás |

## 5. Validación automática de logs

```bash
python validar_logs_runtime.py \
  --server server-console.txt \
  --client cliente-admin-console.txt \
  --client cliente-usuario-console.txt \
  --config configuracion_servidor_actual.json \
  --output validacion_runtime
```

Genera:

```text
validacion_runtime.json
validacion_runtime.md
```

Busca específicamente:

- `required mod ... not found`;
- `WorldDictionaryException`;
- `Missing dictionary script`;
- `IllegalFormatConversionException`;
- diferencias de checksum o versión;
- errores Lua;
- estados de animación ausentes;
- desconexiones antes de completar la carga;
- carga global de `ECZ_Idioma` antes de iniciar el menú.

## 6. Partida existente

No borrar `WorldDictionary`, chunks ni archivos de personaje para resolver errores de scripts. Primero debe restaurarse la definición ausente o corregirse la diferencia entre servidor y cliente.

La entidad crítica que debe conservarse es:

```text
Base.IDBFS_LiquidBarrelRack
```

La prueba debe incluir objetos de destilería construidos antes de la actualización, vehículos existentes, prendas antiguas, contenedores con loot generado y personajes persistentes.
