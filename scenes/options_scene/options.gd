extends Control
class_name Options

@onready var file_select_cover: ColorRect = $FileSelectCover
@onready var key_input_file_dialog: FileDialog = $Buttons/OutputServerButton/KeyInputFileDialog
@onready var output_server_config: OutputServerConfig = $OutputServerConfig
@onready var button_sfx_audio_stream_player: AudioStreamPlayer = $ButtonSFXAudioStreamPlayer
@onready var advanced_interface_enabler_button: Button = $Buttons/AdvancedInterfaceEnablerButton

func _ready() -> void:
	output_server_config.hide()

func _on_close_button_pressed() -> void:
	hide()

func _on_output_server_button_pressed() -> void:
	file_select_cover.show()
	key_input_file_dialog.popup()
	await key_input_file_dialog.file_selected
	var path = key_input_file_dialog.current_file
	if is_key_valid(path):
		output_server_config.read_key_input_file_dialog(path)
	file_select_cover.hide()

func is_key_valid(path: String) -> bool:
	var key_valid: bool = true
	var file_name: String = path.get_file().get_basename()
	var file_extension: String = path.get_extension()
	if file_extension != "keywu":
		key_valid = false
		OS.alert(
			"This file is not a key." + "\n" + "Wrong file extension.",
			"Wake Up.exe"
		)
	if file_name != "credential":
		key_valid = false
		OS.alert(
			"This file is not a key." + "\n" + "Wrong file name.",
			"Wake Up.exe"
		)
	
	return key_valid

func button_hover() -> void:
	if button_sfx_audio_stream_player.playing:
		button_sfx_audio_stream_player.stop()
	button_sfx_audio_stream_player.stream = load("res://assets/sfxs/button_hover.wav")
	button_sfx_audio_stream_player.pitch_scale = randf_range(0.2, 5.0)
	button_sfx_audio_stream_player.play()

func button_clicked() -> void:
	if button_sfx_audio_stream_player.playing:
		button_sfx_audio_stream_player.stop()
	button_sfx_audio_stream_player.stream = load("res://assets/sfxs/button_clicked.wav")
	button_sfx_audio_stream_player.pitch_scale = randf_range(3.5, 5.0)
	button_sfx_audio_stream_player.play()


func _on_key_input_file_dialog_canceled() -> void:
	file_select_cover.hide()


func _on_advanced_interface_enabler_button_pressed() -> void:
	file_select_cover.show()
	key_input_file_dialog.popup()
	await key_input_file_dialog.file_selected
	var path = key_input_file_dialog.current_file
	if is_key_valid(path):
		Settings.advanced_interface_visibility = not(Settings.advanced_interface_visibility)
		if not Settings.advanced_interface_visibility:
			advanced_interface_enabler_button.text = "CHANGE ADVANCED INTERFACE VISIBILITY (NOT ENABLE)"
		else:
			advanced_interface_enabler_button.text = "CHANGE ADVANCED INTERFACE VISIBILITY (ENABLE)"
	file_select_cover.hide()
