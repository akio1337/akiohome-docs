# Script
El script adjunto permite hacer un backup de Firefly, tanto de la base de datos como de los archivos segun se recomienda en la documentación oficial: https://docs.firefly-iii.org/how-to/firefly-iii/advanced/backup/

Se ha configurado un Cron para que ejecute el script cada madrugada a las 1:00AM:
```bash
1 1 * * * sudo bash /home/akio1337/akiohome/produccion/firefly/firefly-iii-backuper.sh backup /mnt/syno/backup/firefly/firefly-backup_$(date '+%F').tar 
```
