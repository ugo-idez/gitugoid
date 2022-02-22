<?php
/**
 * Description of Connexion *
 * @author Dominique_2
 */
class Connexion {
    
    private $_dbh;   // Chaine de connexion
    
    /**
     * Connexion persistante au serveur
     * @return \PDO Connexion
     */    
    public function __construct(){
        // Définition des variables de connexion
        $user = "adminbdarbre";
        $pass = "mdpbdarbre";
        $dsn ='mysql:host=localhost;dbname=bdarbre'; //Data Source Name

        // Connexion 
        try {
            $this->_dbh = new PDO($dsn, $user, $pass, array(PDO::ATTR_PERSISTENT=>true, 
            PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES \'UTF8\''));  // Connexion persistante            
        }
        catch (PDOException $e) {
            die("Erreur : " . $e->getMessage());
        }        
    }
    /** afficherErreurSQL : 
     *  Affichage de messages lors l'accès à la bdd avec une requete SQL
     *  @param $message	: message a afficher
    */		
    function afficherErreurSQL($message, $sql="") {
        echo $message . "<br />" . $sql . "<br />"; 
        $info = $this->_dbh->errorInfo();
        echo "Code erreur : " . $info[0] . ", Message : " . $info[2];      
        die();
    }
    function dbh() {
        return $this->_dbh;
    }
}
