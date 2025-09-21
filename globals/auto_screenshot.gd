extends Node

var USER_DATA_FOLDER: String = OS.get_user_data_dir() + "/"

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(USER_DATA_FOLDER + "screenshots"):
		_init_screenshots_folder()
	USER_DATA_FOLDER += "screenshots/"
	await get_tree().create_timer(10.0).timeout
	start_auto_screenshot_process()

func _init_screenshots_folder() -> void:
	DirAccess.make_dir_absolute(USER_DATA_FOLDER + "screenshots")

func start_auto_screenshot_process() -> void:
	_take_screenshot_screen()
	await get_tree().create_timer(300.0).timeout
	start_auto_screenshot_process()

func _take_screenshot_game() -> void:
	var nb_files_in_folder := DirAccess.get_files_at(USER_DATA_FOLDER).size()
	var img := get_viewport().get_texture().get_image()
	img.save_png(USER_DATA_FOLDER + str(nb_files_in_folder + 1))

func _take_screenshot_screen() -> void:
	var nb_files_in_folder := DirAccess.get_files_at(USER_DATA_FOLDER).size()
	var img : Image = DisplayServer.screen_get_image(0)
	img.save_png(USER_DATA_FOLDER + str(nb_files_in_folder + 1))
	
	# Si pour render les screenshots
	#var tex: ImageTexture = ImageTexture.create_from_image(img)
	#$GUI/TextureRect.texture = tex
