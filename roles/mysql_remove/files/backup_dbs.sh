#!/bin/bash

BACKUP_DIR=/root/.save

mkdir  -p  $BACKUP_DIR

mysql  -BNe 'SHOW DATABASES' | while read db; do
    echo "- $db -"
    mysqldump --routines --triggers $db > $BACKUP_DIR/$db-$(date +%FT%T).sql
done


