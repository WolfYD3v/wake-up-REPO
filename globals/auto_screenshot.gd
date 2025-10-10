extends Node

signal taking_screenshot

var USER_DATA_FOLDER: String = OS.get_user_data_dir() + "/"

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(USER_DATA_FOLDER + "screenshots"):
		_init_screenshots_folder()
	USER_DATA_FOLDER += "screenshots/"
	await get_tree().create_timer(10.0).timeout
	start_auto_screenshot_process()

func _init_screenshots_folder() -> void:
	DirAccess.make_dir_absolute(USER_DATA_FOLDER + "screenshots")

func delete_screenshots() -> void:
	for screenshot: String in DirAccess.get_files_at(USER_DATA_FOLDER):
		DirAccess.remove_absolute(USER_DATA_FOLDER + screenshot)

func start_auto_screenshot_process() -> void:
	take_screenshot_screen()
	await get_tree().create_timer(300.0).timeout
	start_auto_screenshot_process()

func take_screenshot_game() -> Image:
	taking_screenshot.emit()
	var nb_files_in_folder : int = DirAccess.get_files_at(USER_DATA_FOLDER).size()
	var img : Image = get_viewport().get_texture().get_image()
	img.save_png(USER_DATA_FOLDER + str(nb_files_in_folder + 1) + ".png")
	return img

func take_screenshot_screen() -> Image:
	taking_screenshot.emit()
	var nb_files_in_folder : int = DirAccess.get_files_at(USER_DATA_FOLDER).size()
	var img : Image = DisplayServer.screen_get_image(0)
	img.save_png(USER_DATA_FOLDER + str(nb_files_in_folder + 1) + ".png")
	return img

func get_screenshot() -> ImageTexture:
	var random_screenshot: String = str(randi_range(1, DirAccess.get_files_at(USER_DATA_FOLDER).size()))
	var img: Image = Image.new()
	img.load(USER_DATA_FOLDER + random_screenshot + ".png")
	var tex: ImageTexture = ImageTexture.create_from_image(img)
	return tex
