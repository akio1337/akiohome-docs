#! /bin/bash
#Script para hacer backup de las notas
rclone sync  google:backup_akiohome_notas /mnt/hdd/notas/ --exclude=.*/ --progress --log-file ~/.config/rclone.log
