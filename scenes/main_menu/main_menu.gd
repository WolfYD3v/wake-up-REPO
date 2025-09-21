extends Node3D

const SIMULATION_1 = preload("uid://dx235g3ifssim")

func close_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/simulations/all_simulations/simulation_1.tscn")

func _on_play_button_pressed() -> void:
	close_main_menu()
