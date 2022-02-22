#!/bin/bash
datem=$(date +%W)
dates=$(($datem %4))
host=sio@10.121.38.95

#sv hebdomadaires avec rotation sur 4 semaines
scp $host:/home/frederic.duhin/PHPProjects/ProjetBucheron/bdarbre.sql /root/sv/bdarbre-$dates.sql

gzip bdarbre-$dates.sql;mv bdarbre-$dates.sql.gz hebdomadaires/

