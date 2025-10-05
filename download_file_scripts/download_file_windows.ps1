$FileUrl = "[REMPLACEZ_PAR_VOTRE_URL_DE_TELECHARGEMENT]"
$DownloadPath = "$env:USERPROFILE\download_test.txt"
$DesktopPath = "$env:USERPROFILE\"

# 1. Télécharger le fichier
Write-Host "Downloading '$FileUrl' as '$DownloadPath'..."
try {
    Invoke-WebRequest -Uri $FileUrl -OutFile $DownloadPath
	Write-Host "Download complet."
} catch {
	Write-Host "Error while downloading: $($_.Exception.Message)"
    exit 1
}

# 2. Ouvrir le répertoire dans l'Explorateur de fichiers
Write-Host "Opening file explorer..."
Invoke-Item $DesktopPath
