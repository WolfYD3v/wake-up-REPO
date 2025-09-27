extends Control
class_name Options

@onready var file_select_cover: ColorRect = $FileSelectCover
@onready var key_input_file_dialog: FileDialog = $Buttons/OutputServerButton/KeyInputFileDialog
@onready var output_server_config: OutputServerConfig = $OutputServerConfig

func _ready() -> void:
	output_server_config.hide()

func _on_close_button_pressed() -> void:
	hide()

func _on_output_server_button_pressed() -> void:
	file_select_cover.show()
	key_input_file_dialog.popup()

func _on_key_input_file_dialog_file_selected(path: String) -> void:
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
