<?php

date_default_timezone_set('Europe/Paris');
$day = array("Monday", "Tuesday", "Wednesday", "Thursday", "Friday");
//Si c'est la fin de la semaine 
if (date('d-m-Y', strtotime("now")) == date('d-m-Y', strtotime("Friday"))) {
    for ($i = 0; $i < count($day); $i++) {
        echo '<option>' . date('d-m-Y', strtotime("next".$day[$i])) . "</option>";
    }
} //Si c'est le début de la semaine 
else{
    for ($i = 0; $i < count($day); $i++) {
            echo '<option>' . date('d-m-Y', strtotime("this week".$day[$i])) . "</option>";
    }
};

/*On peux comaprer les dates pour savoir si la date d'ajourd'hui est plus grande que celle d'hier
if (strtotime("now") > strtotime($day[0])) {
    echo 'coucou';
};
echo date("d-m-y", strtotime("this week monday"));*/
