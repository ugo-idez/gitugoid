###Variables

# Chemin de l'exécutable pour l'installation du logiciel
$path = "\\srv-DHCP-DNS\Applications$"

# Chemin vers lequel nous allons copier l'exécutable sur le poste client
$tmp = "C:\Windows\Temp"

# Nom de l'exécutable
$name = "7z2107-x64.exe"

# Argument pour le mode silencieux
$arg = "/S"

# La version que l'on veut du logiciel
$VersionVoulu = "21.07"

# Chemin de l'exécutable du logiciel que on veut installer
$ProveExist = "C:\Program Files\7-Zip\7z.exe"

# Commande pour connaître la version du logiciel installé
$commandversion = (Get-ItemProperty -Path "C:\Program Files\7-Zip\7z.exe" -ErrorAction SilentlyContinue).VersionInfo.FileVersion


### Script

if (($commandversion -eq $null) -or ($commandversion -ne $null -and $commandversion -ne $VersionVoulu)) {

    if ($commandversion -ne $null) {
        Write-Host "Le logiciel va être mis à jour : $commandversion --> $VersionVoulu"

    }

if ($commandversion -eq $null) {

# Si le fichier existe sur le partage, on le copie dans notre dossier temporaires
if (Test-Path "$path\$name") {

    Copy-Item "$path\$name" "$tmp" -Force

# Si le fichier existe dans notre dossier temporaire, on l'exécute de façon silencieuse
if (Test-Path "$tmp\$name") {

    Start-Process -Wait -FilePath $tmp\$name -ArgumentList /S

}

Remove-Item "$tmp\$name"

}

} else {

    Write-Warning "Le fichier n'est pas disponible sur le partage !"

}

} else {

    Write-Host "Le logiciel est déjà installé dans la bonne version"

}