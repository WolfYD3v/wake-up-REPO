extends Control
class_name OutputServerConfig

@onready var server_output_ip_adress_line_edit: LineEdit = $Nodes/ServerOutputIpAdressLineEdit
@onready var cover: ColorRect = $Cover

var base_server_output_ip_adress: String = "192.168.13.12"

func read_key_input_file_dialog(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var file_content: Dictionary = JSON.parse_string(file.get_as_text())
	print(file_content)
	
	if not file_content.get("can_edit_output_server_ip_adress"):
		OS.alert("You can't use this section.", "Wake Up.exe")
		hide()
		return
	if not file_content.get("id") in [0.0, 1.0, 2.0]:
		OS.alert("The id does not exist in our database.", "Wake Up.exe")
		hide()
		return
	
	show()


func _on_reset_button_pressed() -> void:
	server_output_ip_adress_line_edit.text = base_server_output_ip_adress

func _on_apply_button_pressed() -> void:
	cover.show()
	if server_output_ip_adress_line_edit.text != base_server_output_ip_adress:
		await get_tree().create_timer(0.1).timeout
		OS.alert(
			"Connection to the output server...",
			"Wake Up.exe"
		)
		await get_tree().create_timer(5.0).timeout
		OS.alert(
			"Wrong IP adress.",
			"Wake Up.exe"
		)
		server_output_ip_adress_line_edit.text = base_server_output_ip_adress
	cover.hide()

func _on_close_button_pressed() -> void:
	hide()
