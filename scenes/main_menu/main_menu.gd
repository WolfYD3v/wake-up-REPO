extends Node3D

@onready var camera_3d = $Camera3D
@onready var options: Options = $GUI/Options
@onready var dev_intro: DevIntro = $GUI/DevIntro
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const SIMULATION_1 = preload("uid://dx235g3ifssim")

func close_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/simulations/all_simulations/simulation_1.tscn")

func _on_play_button_pressed() -> void:
	close_main_menu()

func _ready() -> void:
	audio_stream_player.volume_db = 24
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	audio_stream_player.play()
	await dev_intro.dev_intro_ended
	audio_stream_player.volume_db = -5

func _process(delta: float) -> void:
	$Camera3D.rotate_y(deg_to_rad(2.5 * delta))

func _on_options_button_pressed() -> void:
	options.show()
