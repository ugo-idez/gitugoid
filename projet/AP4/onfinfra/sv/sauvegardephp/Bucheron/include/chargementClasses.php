<?php
    /* Chargement des classes nécessaies à partir des 2 répertoires possibles */
        
    spl_autoload_register('chargerClasse');
	/* $path_current = dirname( __FILE__ );
	echo "Chemin : " .	$path_current; */
	function chargerClasse($class) {		
		$directorys = array(
			'../bdd/',
			'../metier/',
			'bdd/',
			'metier/'
		);
		foreach($directorys as $directory) {
			//see if the file exists
			if(file_exists($directory.$class.'.php')) {
				require_once($directory.$class.'.php');
				break;
			}           
		}
	}

