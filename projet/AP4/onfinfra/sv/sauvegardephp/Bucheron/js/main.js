//Cache et Iniitilise les différents element graphique de selection
var zSelBuch = document.getElementById("selectBuch");
var zSelSect = document.getElementById("selectSecteur");
var searchEspece = document.getElementById("choixEspece");
var zAffichEspece = document.getElementById("selectEspece");
zSelBuch.hidden = true;
zSelSect.hidden = true;
searchEspece.hidden = true;
zAffichEspece.hidden = true;


//Script pour le calendrier
var verrif = 0;
var alertActive = 0;
document.getElementById('selectD').onchange = function () {
    var dateSelect = document.getElementById('selectD').value;
    var date = Date.now();
    if (Date.parse(dateSelect) < date) {
        alert("Date déjà passer")
        alertActive = 1;
        document.getElementById("selectBuch").hidden = true;
        document.getElementById("selectSecteur").hidden = true;
    }
    if (verrif == 0 && alertActive == 0) {
        getBucheron();
        document.getElementById("selectBuch").hidden = false;
        verrif = 1;
    }
    alertActive = 0
    console.log(alertActive + "alert");
    console.log(verrif + "verif");
}
//Fin calendrier

selectBuch.onclick = function () {
    var bucheron = zSelBuch.options[zSelBuch.selectedIndex].value;
    console.log("bucheron =" + bucheron);
    getSecteur()
}

selectSecteur.onclick = function () {
    var secteur = zSelSect.options[zSelSect.selectedIndex].value;
    console.log("secteur = " + secteur)
    getEspece(secteur);
}

function cherche(catalog) {
    //Appel la methode qui charge tous les produits
    document.getElementById("choixEspece").addEventListener("keyup", function () {
        //Initialise la variable options qui contiendra tout le html a integrer
        AffichEspace(catalog, filtre.value);
    })
}

function getBucheron() {
    var file = "include/getBucheron.php"
    var argument, valArgument = null;
    getAll(zSelBuch, file, argument, valArgument);
}

function getSecteur() {
    var file = "include/getSecteur.php";
    var argument, valArgument = null;
    getAll(zSelSect, file, argument, valArgument);
}

function getEspece(secteur) {
    var file = "include/getEspece.php"
    var argument = "selectSecteur="
    getAll(searchEspece, file, argument, secteur)
}

function getAll(placeHTML, fichierPHP, argument, valArgument) {
    var options = "";
    placeHTML.innerHTML = "";
    // Construction de la requ�te
    httpRequest = new XMLHttpRequest();
    // Code s'ex�cutant quand la r�ponse du serveur est arriv�e
    httpRequest.onreadystatechange = function () {
        if (httpRequest.readyState === XMLHttpRequest.DONE) {
            // tout va bien, une r�ponse a �t� re�ue
            if (httpRequest.status === 200) {
                // Succ�s
                //Recupération des données sous forme JSON
                var json = JSON.parse(httpRequest.responseText);
                /* Mise de ce résultat dans une autre fonction (ce qui évite d'utiliser la fonction de base 
                 * qui effectue une requette a chaque fois*/
                var file = json;
                //Appel de la methode cherche qui met en place le système de recherche
                //Appel de la methode d'affichage de tout les produits
                //produitBase(file, filtre.value);
                if (placeHTML == zSelBuch) {
                    afficheBucheron(file);
                }
                if (placeHTML == zSelSect) {
                    afficheSecteur(file);
                }
                if (placeHTML == searchEspece) {
                    console.log("search")
                    cherche(file);
                    zAffichEspece.hidden = false;
                }
            } else {
                alert("Erreur, status : " + httpRequest.status);
                // il y a eu un probl�me avec la requ�te,
                // par exemple la r�ponse peut �tre un code 404 (Non trouv�e)
                // ou 500 (Erreur interne au serveur)
            }
        } else {
            // pas encore pr�te
        }
    };
    // Initialisation et envoi de la requ�te
    httpRequest.open('POST', fichierPHP, true);
    httpRequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    if (argument == null && valArgument == null) {
        httpRequest.send();
    } else {
        httpRequest.send(argument + escape(valArgument));
    }

}

function afficheBucheron(listB) {
    verrif = 0;
    //Initialisation de la variable affiche qui contiendra tout le html a intégrer
    var options = "";
    //parcours la liste des bucherons
    for (var i = 0; i < listB.lesBucherons.length; i++) {
        //Recupération des informations.
        var id = listB.lesBucherons[i].id;
        var nom = listB.lesBucherons[i].nom;
        var prenom = listB.lesBucherons[i].prenom;
        var complet = nom + " " + prenom;
        //ajout du code HTML pour afficher les bucherons dans le select
        options += "<option value='" + id + "'>" + complet + "</option>;"
    }
    //Insertion de la variable dans le html
    document.getElementById("selectBuch").innerHTML = options;
}

function afficheSecteur(listS) {
    zSelSect.hidden = false;
    //Initialisation de la variable affiche qui contiendra tout le html a intégrer
    var options = "";
    //parcours la liste des bucherons
    for (var i = 0; i < listS.lesSecteurs.length; i++) {
        //Recupération des informations.
        var id = listS.lesSecteurs[i].id;
        var libelle = listS.lesSecteurs[i].libelle;
        //ajout du code HTML pour afficher les bucherons dans le select
        options += "<option value='" + id + "'>" + libelle + "</option>;"
    }
    //Insertion de la variable dans le html
    zSelSect.innerHTML = options;
}

/*function cherche(listE) {
    searchEspece.parentNode.hidden = false;
    //Initialisation de la variable affiche qui contiendra tout le html a intégrer
    var options = "";
    //parcours la liste des bucherons
    for (var i = 0; i < listE.lesEspeces.length; i++) {
        //Recupération des informations.
        var libelle = listE.lesEspeces[i].libelle;
        //ajout du code HTML pour afficher les bucherons dans le select
        options += "<option value='" + libelle + "'/>"
    }
    //Insertion de la variable dans le html
    searchEspece.innerHTML = options;
}
*/

function AffichEspace(catalog, saisie) {
    //Initialisation de la variable affiche qui contiendra tout le html a intégrer
    var options = "";
    //si la zone de saisie n'est pas vide, continue la methode
    if (saisie != "") {
        //parcours la liste des produit
        for (var i = 0; i < catalog.lesEpeces.length; i++) {
            //Si la chaine est contenue au début d'un num d'un des elements js, n'affiche que celui ci
            if (catalog.lesEpeces[i].libelle.toLowerCase().indexOf(saisie.toLowerCase()) == 0) {
                //Recupération des informations.
                var libelle = catalog.lesEpeces[i].libelle;
                //ajout du code HTML pour afficher les produits dans la variable
                opt = "<option value='" + libelle + "'>" + libelle + "</option>;"
                /*Si l'id du produit est différent d'une des valeurs des balise option 
                 * présent dans zlProduit alors ajoute ce dernier dans la variable qui servira pour
                 * integrer le html dans zlProduit*/
                if (zAffichEspece.querySelectorAll("option").value != id)
                    //incrémenation de la variable
                    options += opt;
            }
        }
        //Insertion de la variable dans le html
        zAffichEspece.innerHTML = options;
    } else {
        var affiche = "";
        for (var i = 0; i < catalog.lesEpeces.length; i++) {
            //Recupération des informations
            var id = catalog.lesEpeces[i].id;
            var libelle = catalog.lesEpeces[i].libelle;
            //ajout du code HTML pour afficher les produits dans la variable
            affiche += "<option value='" + id + "'>" + libelle + "</option>;"
            //le "+=" veux dire de prendre l'ancien résultat et de l'addition avec le nouveau
        }
        //Insertion dans le html
        zAffichEspece.innerHTML = affiche;
    }
}