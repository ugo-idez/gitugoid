#PowerSHELL (.ps1)

###############
#
# Description: Script qui parcours l'ensemble des répertoires et sous-répertoires du chemin spécifié et enregistre chaque fichiers au format qu'on cherche
#
# Auteur: Ugo IDEZ
#
# Date: 12/10/2002
#
###############

# Paramètres

param (
        [string]$argpath,  #argument correspondant au chemin qu'on veut analyser
        [string]$argexts,  #argument correspondant aux extensions voulues
        [string]$help      #argument qui corrspond à l'aide

        )




# Variables

$destbase = "C:\Users\SIO\Desktop\SvPathExts.csv"     #destination de sauvegarde du fichier
$pathbase = "C:\"                                     #analyse de base: tous les fichiers du disque "C:\"

$path = $argpath
$exts = $argexts

$syntax = "*.exe,*.dll"

#echo "`nLe chemin que vous avez choisi est: $path`n"

# Fonctions

function aide {

echo "

Options :
        - -help /? : affiche l'aide du script
	- -argpath : chemin où analyser les fichiers
	- -argexts : les extensions de fichiers qu'on veut récupérer (sous la forme $syntax ...)

"

}



# Script

$time = [Diagnostics.Stopwatch]::StartNew()     #Affichage du temps d'exécution du script



if ($help -eq "/?") {                                                          # Si l'utilisateur demande de l'aide

aide

}

elseif (($argpath -eq "") -and ($argexts -eq "") -and ($help -eq "")) {        # Si les trois arguments sont nuls --> Analyse de tous les fichiers avec toutes les extensions, résultat sur le Bureau

    echo "`nAnalyse de tout l'ordinateur avec toutes les extensions, fichier sauvegardé sur le bureau.`n"
    Get-ChildItem $pathbase -Recurse | select -Property Name,Length,@{name='Taille';Expression={$_.Length/1GB}},CreationTime,Directory | Export-Csv -Path $destbase -Delimiter ";" -NoTypeInformation

} 

elseif (($argpath -ne "") -and ($argexts -eq "") -and ($help -eq "")) {        # Si le chemin est spécifié mais pas les extensions --> Analyse sur le chemin voulu avec toutes les extensions, résultat sur le Bureau

    echo "`nAnalyse sur le chemin $path avec toutes les extensions, fichier sauvegardé sur le bureau.`n"
    Get-ChildItem $argpath -Recurse | select -Property Name,Length,@{name='Taille';Expression={$_.Length/1GB}},CreationTime,Directory | Export-Csv -Path $destbase -Delimiter ";" -NoTypeInformation
    
} 

elseif (($argpath -eq "") -and ($argexts -ne "") -and ($help -eq "")) {        # Si les extensions sont spécifiés mais que le chemin est nul --> Analyse de tous les fichiers avec les extensions spécifiés, résultat sur le bureau

    echo "`nAnalyse de tous les fichiers avec les extensions $exts, fichier sauvegardé sur le bureau.`n"
    Get-ChildItem $pathbase -Recurse -Include $exts | select -Property Name,Length,@{name='Taille';Expression={$_.Length/1GB}},CreationTime,Directory | Export-Csv -Path $destbase -Delimiter ";" -NoTypeInformation
    #Get-ChildItem Z:\ -Recurse -Include *.exe,*.dll | select -Property Name,Length,@{name='Taille';Expression={$_.Length/1GB}},CreationTime,Directory | Export-Csv -Path 'C:\Users\SIO\Desktop\fichier.csv' -Delimiter ";" -NoTypeInformation

} 

elseif (($argpath -ne "") -and ($argexts -ne "") -and ($help -ne "/?")) {      # Si les deux arguments sont renseignés --> Analyse sur le chemin voulu avec les extensions spécifiés, résultat sur le bureau

    echo "`nAnalyse sur le chemin $path avec les extensions $exts, fichier sauvegardé sur le bureau`n"
    Get-ChildItem $path -Recurse -Include $exts | select -Property Name,Length,@{name='Taille';Expression={$_.Length/1GB}},CreationTime,Directory | Export-Csv -Path $destbase -Delimiter ";" -NoTypeInformation

}

else {

echo "

Syntax incorrecte, veuillez suivre cette syntax :


Options :
        - -help /? : affiche l'aide du script
	- -argpath : chemin où analyser les fichiers
	- -argexts : les extensions de fichiers qu'on veut récupérer (sous la forme $syntax ...)

"

}

$time.Stop()

$time  | select -Property Elapsed