extends Node

var _auto_log_inputs_enabled: bool = false
var _inputs: Array[Array] = []
var timer: float = 0.0



func _ready() -> void:
	delete_saved_inputs_file()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not _auto_log_inputs_enabled:
			return
		if event.is_pressed():
			_inputs.append(
				[event.as_text_keycode(), timer]
			)

func _process(_delta: float) -> void:
	timer += 0.01
	await get_tree().create_timer(0.01).timeout

func enable_auto_inputs_logging() -> void:
	_auto_log_inputs_enabled = true

func disable_auto_inputs_logging() -> void:
	_auto_log_inputs_enabled = false

func delete_saved_inputs_file() -> void:
	if FileAccess.file_exists(OS.get_user_data_dir() + "/inputs_file.json"):
		DirAccess.remove_absolute(OS.get_user_data_dir() + "/inputs_file.json")

func save_inputs_as_file() -> void:
	var file = FileAccess.open(OS.get_user_data_dir() + "/inputs_file.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(_inputs, "\t", false, false))
	file.close()
	print("Inputs file created!")
