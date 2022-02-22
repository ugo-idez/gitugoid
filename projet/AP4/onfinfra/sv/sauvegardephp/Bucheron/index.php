<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <meta charset="UTF-8">
        <title></title>
    </head>
    <body>
        <h1>Accueil</h1>
        <button>Affectation</button>

        <br>
        <div>
            <input type="checkbox" id="filtre1" />Affiche que class 1
            <input type="checkbox" id="filtre2" />Affiche que class 2
            <input type="checkbox" id="filtre3"  />Affiche que class 3
            <br>
            <br>
            <form id="coucou">
                <input type="checkbox" class="1" value="case2" ><a>Choix class 1</a><br>
                <input type="checkbox" class="1" value="case3"><a>Choix class 1</a><br>
                <input type="checkbox" class="2" value="case4"><a>Choix class 2</a><br>
                <input type="checkbox" class="2" value="case5"><a>Choix class 2</a><br>
                <input type="checkbox" class="2" value="case6"><a>Choix class 2</a><br>
                <input type="checkbox" class="3" value="case7"><a>Choix class 3</a><br>
            </form>

            <button id="btn">COUCOU BOUTTON</button>
        </div>
    </body>
    <script>
        var tableDonne = [];

        document.querySelector('button').onclick = function () {
            window.location.href = "affectation.php";
        }

        var list = document.getElementById('coucou');
        for (i = 0; i < list.length; i++) {
            list[i].addEventListener("click", function () {
                if (this.checked == true) {
                    tableDonne.push(this.value);
                    console.log(tableDonne);
                    console.log(this.checked);
                }
                if (this.checked == false) {
                    var pos = tableDonne.indexOf(this.value);
                    console.log(tableDonne.indexOf(this.value))
                    tableDonne.splice(pos, 1);
                    console.log(this.value);
                    console.log(tableDonne);
                }
            })
        }



        /*document.getElementById("filtre1").onclick = function () {
         console.log(document.getElementById("filtre1").checked);
         var list = document.getElementById('coucou');
         if (document.getElementById("filtre1").checked == true)
         {
         for (i = 0; i < list.length; i++) {
         if (list[i].className != 1) {
         list[i].hidden = true;
         list[i].nextSibling.hidden = true;
         }
         }
         } else {
         for (i = 0; i < list.length; i++) {
         if (list[i].className != 1) {
         list[i].hidden = false;
         list[i].nextSibling.hidden = false;
         }
         }
         }
         }
         
         
         document.getElementById("btn").onclick = function () {
         var form = document.getElementById("coucou");
         for (i = 0; i<form.length; i++) {
         if (form[i].checked == true) {
         console.log(form[i]);
         }
         }
         }*/
    </script>
</html>
