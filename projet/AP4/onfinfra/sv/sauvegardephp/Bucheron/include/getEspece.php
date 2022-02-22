<?php

header("Content-type:application/json");
include_once 'chargementClasses.php';
// Verification existence d'un produit selectionne
if (isset($_REQUEST['selectSecteur'])) {
    recupEspece();
} else {
    echo 'rien préciser';
}

function recupEspece() {
    $idAddr = $_REQUEST['selectSecteur'];
    $especeSQL = new EspeceSQL();
    $lesEspeces = $especeSQL->readEspeceAddr($idAddr);
    echo(json_encode($lesEspeces));
}

?>