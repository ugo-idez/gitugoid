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
        <link rel="stylesheet" type="text/css" href="css/style.css" />
    </head>
    <body>
        <h1>Affectation</h1>
        <form id="formAffect" method="POST">
            <div id="divCalendar">
                <input type="date" id="selectD">
            </div>
            <div id="divBucheron">
                <select name="selectBuch" id="selectBuch" size="15">
                </select>
            </div>

            <div name="divSecteur" id="divSecteur">
                <select name="selectSecteur" id="selectSecteur" size="15">
                </select>
            </div>

            <div name="divEspece" id="divEspece">
                <input type="text" id="choixEspece">
                <select id="selectEspece" id="selectEspece">
                </select>
            </div>
        </form>
    </body>

    <script src="js/main.js"></script>
</html>
