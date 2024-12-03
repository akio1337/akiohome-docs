#!/bin/bash
#  from Local folder to Google Drive
rclone sync /home/akio1337/paperless/media/documents/originals/ google:backup_paperless  --progress --log-file ~/.config/rclone.log
