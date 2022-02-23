#!/bin/bash

##################
#
# Description: Déploiement de conteneurs Docker
# 
# Auteur: IDEZ Ugo
#
# Date: 11/02/2022
#
##################


if [ "$1" == "--create" ];then

	#on définit le nombre de conteneurs
	nb_machine=1
	[ "$2" != "" ] && nb_machine=$2


	#configuration de min/max
	min=1
	max=0

	#on récupère l'id max	
	idmax=$(docker ps -a --format '{{ .Names }}' | awk -F "-" -v user=$USER '$0 ~ user"-alpine" {print $3}' | sort -r | head -1)

	#on redéfinit min et max
	min=$(($idmax + 1))
	max=$(($idmax + $nb_machine))

	#on créer les conteneurs
	echo "Début de la création du/des conteneurs"
	for i in $(seq $min $max);do
		docker run -tid --name $USER-alpine-$i alpine:latest
		echo "Conteneur $USER-alpine-$i créé"
	done

elif [ "$1" == "--drop" ];then
	echo "Suppression des conteneurs..."
	docker rm -f $(docker ps -a)
	echo "Fin de la suppression"


elif [ "$1" == "--start" ];then
	echo ""
	docker start $(docker ps -a | grep $USER-alpine | awk '{print $1}')
	echo ""


elif [ "$1" == "--ansible" ];then
	echo ""
	echo "L'option est --ansible"
	echo ""


elif [ "$1" == "--infos" ];then
	echo ""
	echo "Informations des conteneurs : "
	echo ""
	for conteneur in $(docker ps -a | grep $USER-alpine | awk '{print $1}');do
		docker inspect -f '   => {{.Name}} - {{.NetworkSettings.IPAddress }}' $conteneur
	done
	echo ""


else
#si aucune options n'est specifie, on affiche l'aide

echo "

Options :
	- --create : lancer des conteneurs

	- --drop : supprimer les conteneurs crées par le script

	- --infos : caractéristiques de conteneurs (ip, nom, user...)

	- --start : redémarrage des conteneurs

	- --ansible : déploiement arborescence ansible

"
fi
