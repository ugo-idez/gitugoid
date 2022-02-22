<?php

header("Content-type:application/json");
include_once 'chargementClasses.php';
//Recupération des  prodtuis
$secteurSQL = new SecteurSQL();
$lesSecteurs = $secteurSQL->readAllSecteur();
//Mise en format JSON
echo(json_encode($lesSecteurs));
?>