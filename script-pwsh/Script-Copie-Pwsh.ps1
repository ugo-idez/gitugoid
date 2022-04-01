#PowerShell (.ps1)

###############
#
# Description: Script qui va copier ou déplacer des fichiers à partir d'une source à une destination, avec un filtre (les extensions de fichiers), 
# de façon récursive ou non en s'appuyant sur un fichier sous format csv. On y affichera aussi le nombre de fichiers copiés, le volume copié, le nombre d'erreurs
# et on affichera une barre de progression qui se basera sur le nombre de fichiers à copier au total.
#
# Auteur: Ugo IDEZ
#
# Date: 28/03/2022
#
##############

#region Variables ##################################################################

$path = "C:\Scripts\Copie-ps1\copie-ps1.csv"                # Chemin du fichier csv sur lequel on s'appuiera
$logfile = "C:\Scripts\Copie-ps1\slog.log"            # Chemin du fichier de log
$conclusion = "C:\Scripts\Copie-ps1\conclusion.txt"

$filecsv = Import-CSV -Path $path -Delimiter ";"            # Importation du fichier csv

$NbFichiersCopies = 0                                               # On initialise le compteur (pour par la suite compter le nombre de fichiers copiés)
$NbFichiersIgnores = 0
$erreur = 0

#endregion





#region DefFonction #################################################################

function log ( $event ) {

    $date = Get-Date -Format "dd/MM/yyyy hh:mm:ss"
    $string = $date + " " + $event
    
    ADD-Content -path $logfile -value $string	
}

function CopieDiskTODisk {

    $pourcentage = $i/$total *100
    #$NbFichiersCopies+=1
    Write-Progress -Activity "Copie du fichier" -Status "Fichier en cours de copie dans {$src}: $($fichier.Name), $i/$total" -PercentComplete $pourcentage      # Barre de progression se basant sur NombreDeFichiersCopiés/NombreDeFichiersRestants
    # On copie les fichiers
    #Copy-Item $fichier $dest -Include $filtre
    $fichier| Copy-Item -Destination $dest -Recurse -Container -Include $filtre
    #Get-ChildItem C:\Users\uidez\Documents\Test\Source| Copy-Item -Destination C:\Users\uidez\Documents\Test\Cible -Recurse -Container -Include *.*                                                                                                                          
    Start-Sleep -Milliseconds 15
    log "$fichier.Name copié sur $dest"

}

#endregion




#region Script

# Début de l'enregistrement des logs

$filecsv|Format-Table                                       # On affiche d'abord les différentes lignes du fichier csv
log "`nLancement du script"
$Error.Clear()                                              # On nettoie les erreurs de la session
$ErrorActionPreference = "continue"

foreach ( $line in $filecsv ) {                             # Pour chaque ligne du fichier csv

    $src = $line.Source                                             # Source
    $dest = $line.Cible                                             # Destination
    $filtre = $line.Filtre                                          # Filtre
    $fichiers = Get-ChildItem $src        # On récupère les fichiers dans les sources récursivement
    #Get-ChildItem C:\Users\uidez\Documents\Test\Source
    $fichiersnorecurse = Get-ChildItem -Path $src -Filter $filtre   # On récupère les fichiers dans les sources non-récursivement

    if ( $line.'Copy/Move' -eq "C" ) {                              # Dans le cas d'une copie

        if ( $line.Recurse -eq "O" ) {                                     # Copie des fichiers récursivement
         
            $i=0
            $total = $fichiers.count

            foreach ( $fichier in $fichiers ) {                                   # Pour chaque fichiers qu'on doit copier
    
                        # Compteur dans la boucle foreach fichier pour la barre de progression (fichier en cours de copie)
                        $i+=1

                        $FichierCible = $dest+'\'+$fichier.Name
                        $ACopier = $False

                        if ( (Test-Path $FichierCible) -eq $False ) {

                            $ACopier = $true

                        } else {

                            $file = Get-Item $FichierCible

                            if ( ($fichier.Length -ne $file.Length) -or ( $fichier.LastWriteTime -ne $file.LastWriteTime ) ) {

                                $ACopier = $true

                            }

                        }
                            
                        if ( $ACopier -eq $true ) {
                                                                                  
                            CopieDiskTODisk
                            $NbFichiersCopies+=1
                            $long = $fichier.Length/1GB     # On récupère la longueur de chaque fichiers en Go
                            $volume = $volume + $long

                        } else {

                            $NbFichiersIgnores+=1
                            #$erreur+=1
							log "$fichier.Name ignoré"

                        }

                    }

        if ( $line.Recurse -eq "N" ) {                                     # Copie des fichiers non-résursivement

            foreach ( $fichier in $fichiernorecurse ) {
    
                        Copy-Item $fichier $dest -Include $filtre
                        $NbFichiersCopies+=1

                    }
        
            }

        }

    }

    Write-Host "`nCopie des fichiers de $src à $dest avec comme extensions $filtre`n"

}

$erreur = $erreur + $Error.Count

Write-Host "$NbFichiersCopies fichier(s) copiés pour $volume Go"
Write-Host "$NbFichiersIgnores fichier(s) ignorés"
Write-Host "$erreur erreur(s)."



if ( $error -eq $null ) {

    Set-Content -path $conclusion -value "Ok $NbFichiersCopies pour $volume Go "

} else {

    Set-Content -path $conclusion -value "Critical x$erreur erreur(s) $NbFichiersCopies fichiers copiés pour $volume Go"

}

log "Fin de l'exécution"

#endregion