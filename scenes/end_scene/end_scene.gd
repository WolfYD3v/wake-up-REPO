extends Node3D

@onready var computer_screen: MeshInstance3D = $Computer/Screen

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	get_tree().set_auto_accept_quit(false)

func _process(_delta: float) -> void:
	update_computer_screen()
	await get_tree().create_timer(3.5).timeout

func update_computer_screen() -> void:
	var img: Image = DisplayServer.screen_get_image(0)
	var tex: ImageTexture = ImageTexture.create_from_image(img)
	var mat: StandardMaterial3D = computer_screen.get_surface_override_material(0)
	mat.albedo_texture = tex
	computer_screen.set_surface_override_material(0, mat)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("Cannot close this window, sorry!")

func _on_button_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, false)
	get_tree().set_auto_accept_quit(true)
