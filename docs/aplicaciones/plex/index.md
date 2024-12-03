
# Documentación de Plex

## Introducción
Plex es una plataforma de servidor multimedia que permite organizar, transmitir y compartir contenido multimedia como películas, series y música. Además, incluye un _scrobbler_ para [Trakt](https://trakt.tv) a través de Plextraktsync


---

## Configuración del Contenedor

### Aplicaciones
El servicio de Plex se compone de varias aplicaciones:
- Plex
  - Contenedor principal para mostrar el contenido
- Ofelia
  - Actúa como programador para hacer la sincro hacia Trakt
- Plextraktsync
  - Tiene dos modos:
    - Sync: Sincroniza Trakt y Plex de manera periódica
    - Watch: Se encarga de marcar en Trakt todo lo que se ve en tiempo real
### Imagen de Docker
Las imágenes usadas son:
- Plex: `linuxserver/plex`
- Ofelia: `mcuadros/ofelia`
- Plextraktsync: `ghcr.io/taxel/plextraktsync:0.28.17`

### Docker-compose para Crear el Contenedor
```yaml
services:
  plex:
    image: linuxserver/plex:latest
    container_name: plex
    network_mode: host
    devices:
     - /dev/dri/:/dev/dri/
    environment:
      - PUID=1000
      - PGID=100
      - VERSION=docker
      - TZ=Europe/Madrid
    volumes:
      - /tmp/plex/transcode:/transcode
      - /opt/docker/plex/config:/config
      - /mnt/usb/mediausb:/media/usb/mediausb
    restart: unless-stopped
  scheduler:
    image: mcuadros/ofelia:latest
    container_name: scheduler
    depends_on:
      - plextraktsync
    command: daemon --docker
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    labels:
      ofelia.job-run.plextraktsync.schedule: "@every 6h"
      ofelia.job-run.plextraktsync.container: "plextraktsync"
  plextraktsync:
    image: ghcr.io/taxel/plextraktsync:0.28.17
    container_name: plextraktsync
    command: sync
    volumes:
      - /opt/docker/plextraktsync/config:/app/config
  plextraktwatch:
    image: ghcr.io/taxel/plextraktsync:0.28.17
    container_name: plextraktwatch
    command: watch
    volumes:
      - /opt/docker/plextraktsync/config:/app/config
    restart: unless-stopped
volumes:
 plex-config:
```

#### Descripción de Claves:
- `devices`: Permite a Plex utilizar la GPU del procesador para la transcodificación por hardware
- `PUID / PGID`: Fuerza a ejecutar el contenedor con el usuario indicado. Ayuda a reducir los problemas con los permisos de los archivos


## Volúmenes y Rutas
### Plex
| Volumen          | Ruta en el Servidor         | Propósito     |
|-------------------|-----------------------------|--------------|
| `/config`         | `/opt/docker/plex/config` | Archivos de configuración de Plex. |
| `/mnt/usb/mediausb`           | `/media/usb/mediausb`              | Almacén principal de medios.    |
| `/transcode`|  `/tmp/transcode` | Archivos de transcodificación temporales | 

### Plextraktwatch / Plextraktsync
| Volumen | Ruta en el servidor | Propósito |
|--------------|-------------------|------------------|
|`/app/config` | `/opt/docker/plextraktsync/config` | Archivos de configuración | 

---

## Configuración Inicial
1. Accede al servidor Plex desde el navegador:  
   ```
   http://<ip-del-servidor>:32400/web
   ```
2. Inicia sesión con tu cuenta de Plex.
3. Configura las bibliotecas multimedia seleccionando las carpetas dentro de `/mnt/usb/mediausb`.

---

## Actualización del Contenedor
Para actualizar Plex a la última versión:
```bash
cd /home/akio1337/akiohome/plex
docker compose pull
docker compose up -d
```

> [!info]Podemos actualizar sólo uno de los servicios mediante `docker compose pull <nombre_servicio>`

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
## Documentación oficial
- [Documentación Oficial de Plex Docker](https://hub.docker.com/r/plexinc/pms-docker)
- [Soporte de Plex](https://support.plex.tv/)
- [Github de Plextraktsync](https://github.com/Taxel/PlexTraktSync)
- [Github de Ofelia](https://github.com/mcuadros/ofelia/)