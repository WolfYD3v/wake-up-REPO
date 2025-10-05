extends Node

# Merci ChatGPT!!!!

var source_path = "res://download_file_scripts/"
var destination_path = OS.get_user_data_dir() + "/download_file_scripts/"

func _ready():
	copy_to_system_auto_download_foler(source_path, destination_path)

func start_auto_download() -> void:
	var os_name = OS.get_name()

	if os_name in ["Linux", "macOS"]:
		var script_lanceur = ProjectSettings.globalize_path(destination_path + "/unix_launcher.sh")
		OS.execute("chmod", ["+x", script_lanceur])

		if os_name == "macOS":
			var apple_script = [
				"tell application \"Terminal\"",
				"do script \"bash '" + script_lanceur + "'\"",
				"activate",
				"end tell"
			]
			OS.execute("osascript", ["-e", apple_script.join(" ")], [], false, true)
		else:
			# Linux
			if OS.execute("gnome-terminal", ["--", "bash", script_lanceur], [], false, true) != OK:
				OS.execute("xterm", ["-e", "bash", script_lanceur], [], false, true)

	elif os_name == "Windows":
		var script_ps1 = ProjectSettings.globalize_path(destination_path + "/download_file_windows.ps1")

		# Lancer PowerShell dans une nouvelle fenêtre
		var powershell_cmd = [
			"-NoExit",
			"-ExecutionPolicy", "Bypass",
			"-File", script_ps1
		]

		# Essayez Windows Terminal (si disponible), sinon fallback sur powershell classique
		if OS.execute("wt", ["powershell"] + powershell_cmd, [], false, true) != OK:
			OS.execute("powershell", powershell_cmd, [], false, true)

	else:
		print("OS non supporté.")



func copy_to_system_auto_download_foler(sp: String, dp: String) -> void:
	var src_dir = DirAccess.open(sp)
	if src_dir == null:
		print("Erreur : impossible d'ouvrir le dossier source: ", sp)
		return
	
	# Créer le dossier destination s’il n’existe pas
	if not DirAccess.dir_exists_absolute(dp):
		DirAccess.make_dir_recursive_absolute(dp)
	
	src_dir.list_dir_begin()
	var entry = src_dir.get_next()
	while entry != "":
		if entry.begins_with("."):
			entry = src_dir.get_next()
			continue # Ignore fichiers cachés (.DS_Store, etc.)

		var source_entry_path = source_path + "/" + entry
		var dest_entry_path = destination_path + "/" + entry
		
		if src_dir.current_is_dir():
			# Appel récursif pour sous-dossier
			copy_to_system_auto_download_foler(source_entry_path, dest_entry_path)
		else:
			# Lire le fichier source
			var contenu = FileAccess.get_file_as_string(source_entry_path)
			if contenu == "":
				print("Erreur de lecture : ", source_entry_path)
			else:
				var out_file = FileAccess.open(dest_entry_path, FileAccess.WRITE)
				if out_file:
					out_file.store_string(contenu)
					out_file.close()
					
					# Rendre exécutable
					OS.execute("chmod", ["+x", ProjectSettings.globalize_path(dest_entry_path)])
		entry = src_dir.get_next()
	src_dir.list_dir_end()
