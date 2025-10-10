extends Node3D

@onready var computer_screen: MeshInstance3D = $Computer/Screen
@onready var credits_label: RichTextLabel = $Credits/CreditsLabel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	#get_tree().set_auto_accept_quit(false)
	update_computer_screen()
	await get_tree().create_timer(5.0).timeout
	audio_stream_player.play(15.0)
	start_credits()

func update_computer_screen() -> void:
	var USER_DATA_FOLDER: String = OS.get_user_data_dir() + "/screenshots/"
	var screenshots: Array = DirAccess.get_files_at(USER_DATA_FOLDER) as Array
	var img: Image = Image.new()
	var tex: ImageTexture
	for screenshot in screenshots:
		img.load(USER_DATA_FOLDER + screenshot)
		tex = ImageTexture.create_from_image(img)
		var mat: StandardMaterial3D = StandardMaterial3D.new()
		mat.albedo_texture = tex
		computer_screen.set_surface_override_material(0, mat)
		await get_tree().create_timer(1.5).timeout
	await get_tree().create_timer(0.5).timeout
	update_computer_screen()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("Cannot close this window, sorry!")

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_Q):
		get_tree().quit()

func start_credits() -> void:
	credits_label.position.y -= 15
	await get_tree().create_timer(0.5).timeout
	if credits_label.position.y >= -1770:
		start_credits()
	else:
		get_tree().quit()
