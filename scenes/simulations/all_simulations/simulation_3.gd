extends Control

@onready var label: Label = $Disconnected/Label
@onready var disconnected: ColorRect = $Disconnected
@onready var static_tv_shader: ColorRect = $StaticTVShader
@onready var advanced_interface: AdvancedInterface = $AdvancedInterface
@onready var start_element: ColorRect = $StartElement
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var ambiance_audio_stream_player: AudioStreamPlayer = $AmbianceAudioStreamPlayer
@onready var black: ColorRect = $Black

var tween

func _ready() -> void:
	black.hide()
	advanced_interface.hide()
	disconnected.hide()
	
	static_tv_shader.hide()
	$StartElement/Label.hide()
	await get_tree().create_timer(1.0).timeout
	static_tv_shader.show()
	$StartElement/Label.show()
	play_sfx("res://assets/sfxs/sim3_fist_sfx.wav", 0.0, 0.2)
	await get_tree().create_timer(1.25).timeout
	start_element.hide()
	ambiance_audio_stream_player.play()
	play_sfx("res://assets/sfxs/camera_sfx.wav", 5.0, 1.0)
	await get_tree().create_timer(0.15).timeout
	static_tv_shader.hide()
	await get_tree().create_timer(13.5).timeout
	ambiance_audio_stream_player.stream_paused = true
	disconnected.show()
	play_sfx("res://assets/sfxs/bip.wav")
	await get_tree().create_timer(0.05).timeout
	OS.alert(
		"You have been disconnected from the Output Display Server, beacuse too many clients are connected." + "\n" + "However you will be reconnected as a'Forced client', which will activate the network trafic debugger and show the advanced interface." + "\n" + "Being a Forced client will take the connection of a non-forced client.",
		"Wake Up.exe"
	)
	label.text = "Reconnection as a Forced client..."
	await get_tree().create_timer(5.0).timeout
	static_tv_shader.show()
	play_sfx("res://assets/sfxs/camera_sfx.wav", 5.0, 1.0)
	await get_tree().create_timer(0.12).timeout
	ambiance_audio_stream_player.stream_paused = false
	static_tv_shader.hide()
	advanced_interface.show()
	await animate_forced_client_reconnection()
	disconnected.hide()

func animate_forced_client_reconnection() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(disconnected, "modulate", Color(1.0, 1.0, 1.0, 0.0), 5.5)
	await tween.finished

func play_sfx(sfx_path: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if audio_stream_player.playing:
		audio_stream_player.stop()
	audio_stream_player.volume_db = volume_db
	audio_stream_player.pitch_scale = pitch_scale
	audio_stream_player.stream = load(sfx_path)
	audio_stream_player.play()


func _on_advanced_interface_asking_started() -> void:
	black.show()
	await advanced_interface.change_visibility_with_animation(advanced_interface.close_size_y)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/simulations/all_simulations/simulation_4.tscn")
