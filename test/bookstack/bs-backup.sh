#!/bin/bash
#Stop bookstack
docker stop bookstack

#Bookstack database dump
docker exec mariadb mysqldump -u root -pPASSWORD bookstackapp > bs-backup.sql

#Compress all bockstack files
cd ~/bookstack/
tar -zcvf "/mnt/hdd/backup/bookstack/bookstack_backup_$(date '+%Y-%m-%d').tar.gz" *

#Start bookstack
docker start bookstack