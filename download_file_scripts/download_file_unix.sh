#!/bin/bash

FICHIER_URL="https://i.imgur.com/AQJaipK.png"
CHEMIN_TELECHARGEMENT="$HOME/capture_038.png"

# 1. Télécharger le fichier
echo "Downloading '$FICHIER_URL' as '$CHEMIN_TELECHARGEMENT'..."
curl -o "$CHEMIN_TELECHARGEMENT" "$FICHIER_URL"

# Vérifier si le téléchargement a réussi
if [ $? -ne 0 ]; then
	echo "Error while downloading '$FICHIER_URL'. Script ended."
	exit 1
fi

echo "Download succesful."

# 2. Ouvrir le répertoire dans l'explorateur de fichiers
# La commande pour ouvrir l'explorateur (Finder/Nautilus) dépend de l'OS
if [[ "$OSTYPE" == "darwin"* ]]; then
	# C'est macOS
	echo "Opening Finder..."
	open "$HOME/"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	# C'est Linux (utilise xdg-open pour la compatibilité entre environnements de bureau)
	echo "Opening file explorer..."
	xdg-open "$HOME/"
else
	echo "Operating system no recognize for the automatic opening."
fi

sleep 2.5s
exit 0
