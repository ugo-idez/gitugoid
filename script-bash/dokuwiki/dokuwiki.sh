#!/bin/bash
chemin=/var/www/html/doku

apt install -y apache2 php php-mbstring php-gd php-xml
cd /root
[ -r dokuwiki-stable.tgz ] || wget http://depl/store/dokuwiki-stable.tgz

if [ $? !=0 ]; then
	echo "$0 : erreurwget" 1>&2
	exit 1
fi
tar xvfz dokuwiki-stable.tgz
[ -d "${chemin}" ] || mkdir "${chemin}"

cp -a dokuwiki-2020-07-29/* "${chemin}"
cd "${chemin}"
chown -R root:root .
chmod -R 755 .
chown -R www-data:www-data data lib conf
exit 0
