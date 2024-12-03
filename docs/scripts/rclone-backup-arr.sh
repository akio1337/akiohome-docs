#! /bin/bash
#Script para sincronizar backups de *arr a GDrive
rclone sync /mnt/hdd/backup/  google:backup_akiohome_arr --exclude=*/manual --exclude=plex/*  --progress --log-file ~/.config/rclone.log
