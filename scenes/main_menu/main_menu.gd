extends Control

const SIMULATION_1 = preload("uid://dx235g3ifssim")

func _ready() -> void:
	SceneManager.set_scene("global_game", get_parent().get_parent())
	SceneManager.set_scene("main_menu", self)

func close_main_menu() -> void:
	var game_scene = SIMULATION_1.instantiate()
	SceneManager.add_scene_to_scenes("game_scene", game_scene)
	SceneManager.hide_scene("main_menu")


func _on_play_button_pressed() -> void:
	close_main_menu()
