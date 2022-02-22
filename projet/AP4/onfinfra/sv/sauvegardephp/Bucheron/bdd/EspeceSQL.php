<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of EspeceSQL
 *
 * @author pierre.perdigues
 */
class EspeceSQL {

    private $_laConnexion;

    function __construct() {
        $this->_laConnexion = new Connexion();
    }

    function readEspeceAddr($adresse) {  
        $stmt = $this->_laConnexion->dbh()->prepare("SELECT DISTINCT libelle FROM espece INNER JOIN arbre ON espece.id = arbre.idEspece WHERE arbre.idAdresse=:adr");
        $stmt->bindValue(':adr', $adresse);
        $valid = $stmt->execute();
        if (!$valid) {
            $this->_laConnexion->afficherErreurSQL("Erreur recherche espece");
        }
        //Retourne dans un array
        $tabEspece = array("lesEspeces" => $stmt->fetchAll(PDO::FETCH_ASSOC));
        return $tabEspece;
    }

}
