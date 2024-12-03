
# Documentación de Plex

## Introducción
Plex es una plataforma de servidor multimedia que permite organizar, transmitir y compartir contenido multimedia como películas, series y música. En este sistema, Plex está desplegado como un contenedor Docker.

---

## Configuración del Contenedor

### Imagen de Docker
Se utiliza la imagen oficial de Plex disponible en Docker Hub: `plexinc/pms-docker`.

### Comando para Crear el Contenedor
```bash
docker run -d \
  --name plex \
  --network=host \
  -e TZ="Europe/Madrid" \
  -e PLEX_CLAIM="<token_de_reclamación>" \
  -v /ruta/a/config:/config \
  -v /ruta/a/medios:/data \
  plexinc/pms-docker
```

#### Descripción de Parámetros:
- `--network=host`: Permite a Plex comunicarse directamente con la red del host.
- `-e TZ`: Establece la zona horaria.
- `-e PLEX_CLAIM`: Token para vincular el servidor Plex a tu cuenta.
- `-v /config`: Directorio para los archivos de configuración de Plex.
- `-v /data`: Carpeta donde están almacenados tus archivos multimedia.

---

## Volúmenes y Rutas
| Volumen          | Ruta en el Servidor         | Propósito                       |
|-------------------|-----------------------------|----------------------------------|
| `/config`         | `/home/usuario/docker/plex/config` | Archivos de configuración de Plex. |
| `/data`           | `/mnt/medios`              | Almacén principal de medios.    |

---

## Configuración Inicial
1. Accede al servidor Plex desde el navegador:  
   ```
   http://<ip-del-servidor>:32400/web
   ```
2. Inicia sesión con tu cuenta de Plex.
3. Configura las bibliotecas multimedia seleccionando las carpetas dentro de `/data`.

---

## Actualización del Contenedor
Para actualizar Plex a la última versión:
```bash
docker pull plexinc/pms-docker
docker stop plex
docker rm plex
docker run <parámetros_iniciales>
```

> **Nota:** Asegúrate de que los volúmenes de datos persistan para conservar tus configuraciones.

---

## Resolución de Problemas
### Problema: Plex no detecta la red
- **Causa común:** La opción `--network=host` puede estar bloqueada.
- **Solución:** Verifica las configuraciones de red de tu host o prueba exponiendo puertos específicos:
  ```bash
  -p 32400:32400/tcp \
  -p 32400:32400/udp \
  ```

### Problema: No se detectan archivos multimedia
- **Causa común:** Permisos incorrectos en las carpetas compartidas.
- **Solución:** Asegúrate de que el usuario con el que se ejecuta Docker tenga acceso a las carpetas:
  ```bash
  sudo chmod -R 755 /mnt/medios
  ```

---

## Copias de Seguridad

>[!warning] No se hacen copias de seguridad de Plex, son sólo metadatos y ocupa demasiado 

- **Ruta de Configuración:** Respaldar el contenido de `/config`.
- **Comando para respaldar:**
  ```bash
  tar -czvf plex-config-backup.tar.gz /home/usuario/docker/plex/config
  ```

---

## Recursos Externos
- [Documentación Oficial de Plex Docker](https://hub.docker.com/r/plexinc/pms-docker)
- [Soporte de Plex](https://support.plex.tv/)
