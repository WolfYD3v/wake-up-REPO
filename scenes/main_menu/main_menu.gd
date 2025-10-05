extends Node3D

@onready var options: Options = $GUI/Options
@onready var dev_intro: DevIntro = $GUI/DevIntro
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var static_tv_shader: ColorRect = $GUI/StaticTVShader
@onready var sfx_audio_stream_player: AudioStreamPlayer = $SFXAudioStreamPlayer
@onready var transition_color_rect: ColorRect = $GUI/TransitionColorRect
@onready var button_sfx_audio_stream_player: AudioStreamPlayer = $ButtonSFXAudioStreamPlayer

const SIMULATION_1 = preload("uid://dx235g3ifssim")

var camera_rotation: float = 2.5

func close_main_menu() -> void:
	transition_color_rect.modulate = Color(1.0, 1.0, 1.0, 0.0)
	static_tv_shader.show()
	sfx_audio_stream_player.volume_db = 50
	sfx_audio_stream_player.play()
	animation_player.play("quit_main_menu")
	await animation_player.animation_finished
	static_tv_shader.hide()
	get_tree().change_scene_to_file("res://scenes/simulations/all_simulations/simulation_1.tscn")

func _on_play_button_pressed() -> void:
	InputsLogger.delete_saved_inputs_file()
	AutoScreenshot.delete_screenshots()
	close_main_menu()

func _ready() -> void:
	static_tv_shader.hide()
	audio_stream_player.volume_db = 24
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	audio_stream_player.play()
	await dev_intro.dev_intro_ended
	audio_stream_player.volume_db = -5

func _on_options_button_pressed() -> void:
	options.show()

func button_hover() -> void:
	if button_sfx_audio_stream_player.playing:
		button_sfx_audio_stream_player.stop()
	button_sfx_audio_stream_player.stream = load("res://assets/sfxs/button_hover.wav")
	button_sfx_audio_stream_player.pitch_scale = randf_range(0.2, 5.0)
	button_sfx_audio_stream_player.play()

func button_clicked() -> void:
	if button_sfx_audio_stream_player.playing:
		button_sfx_audio_stream_player.stop()
	button_sfx_audio_stream_player.stream = load("res://assets/sfxs/button_clicked.wav")
	button_sfx_audio_stream_player.pitch_scale = randf_range(3.5, 5.0)
	button_sfx_audio_stream_player.play()
