#! /bin/bash
#Script para sincronizar los Docker composes de todos los servicios
rclone sync /home/akio1337/  google:backup_akiohome_composes --include=/*/docker-compose.yml --progress --log-file ~/.config/rclone.log
