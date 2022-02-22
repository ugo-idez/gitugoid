<?php

class BucheronSQL {

    private $_laConnexion;

    function __construct() {
        $this->_laConnexion = new Connexion();
    }

    function readAllBucheron() {
        $stmt = $this->_laConnexion->dbh()->prepare("SELECT id, nom, prenom FROM bucheron");
        $valid = $stmt->execute();
        if (!$valid) {
            $this->_laConnexion->afficherErreurSQL("Erreur recherche bucherons");
        }
// Parcours du jeu d'enregistrement
//Retourne dans un array
        $tabBuchron = array("lesBucherons" => $stmt->fetchAll(PDO::FETCH_ASSOC));
        return $tabBuchron;
    }

}