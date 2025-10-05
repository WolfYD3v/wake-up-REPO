#!/bin/bash

# Chemin absolu vers le script à lancer
SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd)/download_file_unix.sh"

if [[ "$OSTYPE" == "darwin"* ]]; then
	# macOS : on utilise AppleScript pour ouvrir Terminal et lancer le script
	osascript <<EOF
tell application "Terminal"
	do script "bash \"$SCRIPT_PATH\""
	activate
end tell
EOF

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	# Linux : on essaie gnome-terminal, sinon xterm
	if command -v gnome-terminal &> /dev/null; then
		gnome-terminal -- bash -c "\"$SCRIPT_PATH\""
	elif command -v xterm &> /dev/null; then
		xterm -e "bash \"$SCRIPT_PATH\""
	else
		echo "Aucun terminal compatible trouvé (gnome-terminal ou xterm requis)"
		exit 1
	fi
else
	echo "OS non supporté : $OSTYPE"
	exit 1
fi
