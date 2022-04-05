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
Param (
	[string[]]$FichierCsv
)




#region Variables ##################################################################
if ($FichierCsv.length -eq 0){
	$FichierCsv = ".\copie-ps1.csv"
}
If ((Test-path $FichierCsv) -eq $false){
	write-host "Le fichier $FichierCsv n'existe pas!" -ForeGroundColor RED
	Exit -1
}
$Temp=$FichierCsv[0]
$logfile = $Temp.Substring(0,$Temp.length -4)+".log"
$conclusion = $Temp.Substring(0,$Temp.length -4)+".txt"

$ListeDesCopies = Import-CSV -Path $Temp -Delimiter ";"

$NbFichiersCopies = 0
$NbFichiersIgnores = 0
$erreur = 0
$VolumeTotal = 0
$Job=0
#endregion


#Get-ChildItem C:\Users\uidez\Documents\Test\Source -Filter *.zip| Move-Item -Force -Destination C:\Users\uidez\Documents\Test\Cible


#region Definition des Fonctions #################################################################

function log ( $event ) {
	# La fonctiob Log permet d'alimenter un fichier de logs
	
    $date = Get-Date -Format "dd/MM/yyyy hh:mm:ss"
    $string = $date + " " + $event
        Add-Content -path $logfile -value $string	
}

function CopyDisk2Disk {
	# La fonction CopyDisk2Disk permet une copie d'un fichier d'un disque à un autre
    Param ( $Source, $Destination)
    # On copie le fichier
	#write-host "Source.....: $Source"
	#write-host "Destination: $Destination"
    Copy-Item $Source -Destination $Destination
	#Return $True
}

function CreerSousRep {
	# La fonction CreerSousRep va créer sur la destination tous les sous-répertoire contenus dans le chemin
    Param ( $Destination, $Chemin)
	$PathACreer=$Destination
	$Path=$Chemin
	$Pos=$Path.indexof("\")
	While ($Pos -ge 0) {
		$PathACreer=$PathACreer+"\"+$Path.substring(0,$Pos)
		$Path=$Path.substring($Pos+1,$Path.length-($Pos+1))
		if ((Test-Path $PathACreer -PathType Container) -eq $false) {
			Write-Host "   Création du répertoire $PathACreer"
			New-Item -Path $PathACreer -type directory -Force |Out-Null
			Log "Création du répertoire $PathACreer"
		}
		$Pos=$Path.indexof("\")
	}
	#Return $True
}


#endregion

#region Script

# Début de l'enregistrement des logs
log "Lancement du script ###############################"
$Error.Clear()
$ErrorActionPreference = "continue"


# Pour chaque ligne du fichier csv
foreach ( $Copie in $ListeDesCopies ) {

    $src = $Copie.Source
    $dest = $Copie.Cible
    $filtre = $Copie.Filtre
	$Job+=1
	# $SourceNetwork=$false
	
	Write-Host "Job $Job : Copie des fichiers ($filtre)"
	Write-Host "   Source........ $src"
	Write-Host "   Destination... $dest"
	Log "Traitement de $src vers $dest ($filtre)"

	# If ($src.substring(0,2)="\\"){
		# la source est un partage réseau
		# if ($Copie.UserSource.length -gt 0) {
			# $SourceNetwork=$true
			# net use

	# }


	if ( $Copie.Recurse.ToUpper() -eq "O" ) {
		#L'option Recurse est activée
		$ListeDesFichiers = Get-ChildItem -path $src -Recurse -filter $filtre
	}
	Else {
		#Pas de Recurse
		$ListeDesFichiers = Get-ChildItem -path $src -filter $filtre -File
	}

	$i=0
	$total = $ListeDesFichiers.count
	write-host "   $total fichier(s) a examiner"
	

    # pour chaque fichier à copier
	foreach ( $FichierSource in $ListeDesFichiers ) {
		# Compteur dans la boucle foreach fichier pour la barre de progression (fichier en cours de copie)
		$i+=1
		$CheminSource=$FichierSource.Fullname
		$Chemin=$CheminSource.Substring($src.length+1)
		
		CreerSousRep $dest $Chemin
		
		$FichierCibleName = $dest+"\"+$Chemin
		# Recherche sur le fichier à copier existe déjà dans la destination
		$ACopier = $False
		if ( (Test-Path $FichierCibleName) -eq $False ) {
			$ACopier = $true
		} else {
			$FichierCible = Get-Item $FichierCibleName
			if ( ($FichierSource.Length -ne $FichierCible.Length) -or ( $FichierSource.LastWriteTime -ne $FichierCible.LastWriteTime ) ) {
				$ACopier = $true
			}
		}

		# Affichage et barre de progression
		$pourcentage = $i/$total *100
		Write-Progress -Activity "Copie du fichier" -Status "$($FichierSource.Name), $i/$total" -PercentComplete $pourcentage

		if ( $ACopier -eq $true ) {
			# Si Acopier alors copie
			CopyDisk2Disk $($FichierSource.Fullname) $FichierCibleName
			log "$($FichierSource.Name) copié sur $dest"
			Start-Sleep -Milliseconds 15
			$NbFichiersCopies+=1
			$TailleFichier= $fichier.Length/1GB
			$VolumeTotal = $VolumeTotal + $TailleFichier
			# si l'option Move est activée, je supprime le fichier après copie
			if ( $Copie.'CopyMove'.ToUpper() -eq "M" ) {
				Remove-Item $($FichierSource.Fullname) -Force
			}
		}
		else {
			# Sinon le fichier existe déjà.
			$NbFichiersIgnores+=1
			#$erreur+=1
			log "$($FichierSource.Name) ignoré"
		}
	}
}

$NbErreurs = $($Error.Count)
$erreur = $(($erreur + $NbErreurs))
Write-Host ""
Write-Host "$NbFichiersCopies fichier(s) copiés pour $VolumeTotal Go"
Write-Host "$NbFichiersIgnores fichier(s) ignorés"
Write-Host "$erreur erreur(s)."

if ( $erreur -eq '0' ) {
	Set-Content -path $conclusion -value "Ok $NbFichiersCopies fichiers copiés pour $VolumeTotal Go, $NbFichiersIgnores fichier(s) existe(nt) deja. "
} else {
	Set-Content -path $conclusion -value "Critical x $erreur erreur(s), $NbFichiersCopies fichiers copiés pour $VolumeTotal Go"
}

log "Fin de l'exécution ################################"

#endregion