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

#Paramètres

param (
        [string]$arg1, #argument correspondant au chemin voulu
        [string]$arg2, #argument correspondant aux extensions voulues
        [string]$arg3, #argument correspondant aux extensions voulues
        [string]$arg4, #argument correspondant aux extensions voulues
        [string]$arg5  #argument correspondant aux extensions voulues

        )


#Variables

$pathbase = "C:\Users\SIO\Desktop\SvPathBase2.csv"
$path = $arg1

$ext = $arg2,$arg3,$arg4,$arg5


#Script

if ($arg1 -eq "/?") {

    echo "`nLe 1er argument correspond au chemin du fichier et les autres arguments correspondent aux extensions recherchées (maximum 4) (voir description pour plus de détails)`n"

}

if (($arg1 -eq "") -and ($arg2 -eq "") -and ($arg1 -ne "/?")) {        # Si les deux arguments sont nuls --> Sur le Bureau et toutes les extensions

    Get-ChildItem Z:\ -Recurse | select -Property Name,Length,@{name='Taille';Expression={$_.Length/1GB}},CreationTime,Directory | Export-Csv -Path $pathbase -Delimiter ";" -NoTypeInformation
    echo "`nFichier sauvegardé sur le bureau avec toutes les extensions`n"

} elseif (($arg1 -ne "") -and ($arg2 -eq "") -and ($arg1 -ne "/?")) {    # Si le deuxième argument est nul mais pas le premier --> Chemin voulu mais toutes les extensions

    Get-ChildItem Z:\ -Recurse | select -Property Name,Length,@{name='Taille';Expression={$_.Length/1GB}},CreationTime,Directory | Export-Csv -Path "$path\monfichier.csv" -Delimiter ";" -NoTypeInformation
    echo "`nFichier sauvegardé au chemin $path avec toutes les extensions`n"
    
} elseif (($arg1 -eq "") -and ($arg2 -ne "") -and ($arg1 -ne "/?")) {    # Si le premier argument est nul mais pas le deuxième --> Sur le bureau mais avec les extensions voulues

    Get-ChildItem Z:\ -Recurse -Include $ext | select -Property Name,Length,@{name='Taille';Expression={$_.Length/1GB}},CreationTime,Directory | Export-Csv -Path $pathbase -Delimiter ";" -NoTypeInformation
    echo "`nFichier sauvegardé sur le bureau avec comme extensions $arg2,$arg3,$arg4,$arg5.`n"

} elseif (($arg1 -ne "") -and ($arg2 -ne "") -and ($arg1 -ne "/?")) {    # Si les deux arguments sont renseignés --> Chemin et extensions voulues

    Get-ChildItem Z:\ -Recurse -Include $ext | select -Property Name,Length,@{name='Taille';Expression={$_.Length/1GB}},CreationTime,Directory | Export-Csv -Path "$path\monfichier.csv" -Delimiter ";" -NoTypeInformation
    echo "`nFichier sauvegardé au chemin $path avec comme extensions $arg2,$arg3,$arg4,$arg5.`n"

}
