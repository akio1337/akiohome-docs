## Pre-requisitos
Prácticamente todos los servicios de AkioHome se instalan a través de [Docker](), así que primero tenemos que crear el directorio que alojará el proyecto:

```bash
mkdir sonarr
```

## Deploy
Dentro del directorio crearemos un fichero `docker-compose.yml` con el siguiente contenido:

```yaml
version: "2.1"
services:
  sonarr:
   image: lscr.io/linuxserver/sonarr:develop
   container_name: sonarr
   environment:
    - PUID=1026
    - PGID=100
    - TZ=Europe/Madrid
   volumes:
    - /home/akio1337/sonarr/config:/config
    - /mnt/usb/:/mnt/usb/
    - /mnt/syno/:/mnt/syno/
    - /mnt/hdd/backup/sonarr:/config/backup
   ports:
    - 8989:8989
   networks:
    - arr
   labels:
    - flame.type=application
    - flame.name=Sonarr
    - flame.url=http://akiohome:8989
    - flame.icon=television-box
   restart: unless-stopped
networks:
  arr:
    external: true
    name: arr
```
Una vez lo tengamos, levantamos el stack: 

```bash
docker compose up -d
```

## Cosas a tener en cuenta
### Volumenes
- `/mnt/usb/`: Bibliotecas con el contenido de `Sonarr`
- `/mnt/hdd/backup/sonarr`: Directorio con los [backups]() de la aplicación
### Ports
Por ahora hace falta exponer el puerto ya que el acceso por `http` se hace a través de este puerto. Con [Caddy]() o [Nginx Proxy Manager]() se podría despublicar el puerto para que se pueda acceder internamente y sólo a través de `HTTPS`
### Labels
- Etiquetas para la autoprovisión de [Flame]()
### Redes
La red `arr` hace que el resto de contenedores relacionados con Media se vean
