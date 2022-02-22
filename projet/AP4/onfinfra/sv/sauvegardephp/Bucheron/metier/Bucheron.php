<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Bucheron
 *
 * @author pierre.perdigues
 */
class Bucheron {

    private $_id;
    private $_nom;
    private $_prenom;
    private $_login;
    private $_mdp;

    public function __construct($_id, $_nom, $_prenom, $_login, $_mdp) {
        $this->_id = $_id;
        $this->_nom = $_nom;
        $this->_prenom = $_prenom;
        $this->_login = $_login;
        $this->_mdp = $_mdp;
    }

    public function id() {
        return $this->_id;
    }

    public function nom() {
        return $this->_nom;
    }

    public function prenom() {
        return $this->_prenom;
    }

    public function login() {
        return $this->_login;
    }

    public function mdp() {
        return $this->_mdp;
    }

    public function setId($_id): void {
        $this->_id = $_id;
    }

    public function setNom($_nom): void {
        $this->_nom = $_nom;
    }

    public function setPrenom($_prenom): void {
        $this->_prenom = $_prenom;
    }

    public function setLogin($_login): void {
        $this->_login = $_login;
    }

    public function setMdp($_mdp): void {
        $this->_mdp = $_mdp;
    }

}
