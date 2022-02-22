<?php
    /**************************************************************************
    * getProduit.php : Recherche les produits                                 *
    * pour alimenter la liste deroulante zlProduit                            *             
    ***************************************************************************/    

    header("Content-type:application/json");
    include_once 'chargementClasses.php';
    //Recupération des  prodtuis
    $buchSQL = new BucheronSQL();
    $lesBucherons = $buchSQL->readAllBucheron();
    //Mise en format JSON
    echo(json_encode($lesBucherons));
?>