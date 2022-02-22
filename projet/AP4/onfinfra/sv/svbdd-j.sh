#!/bin/bash
datej=$(date +%u)
host=sio@10.121.38.95

#sv journalières avec rotation sur 5 jours
scp $host:/home/frederic.duhin/PHPProjects/ProjetBucheron/bdarbre.sql /root/sv/bdarbre-$datej.sql

gzip bdarbre-$datej.sql;mv bdarbre-$datej.sql.gz journalieres/

