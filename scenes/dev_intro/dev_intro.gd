extends Control
class_name DevIntro

signal dev_intro_ended

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var player_rendered: TextureRect = $PlayerRendered
@onready var static_tv_shader: ColorRect = $StaticTVShader
@onready var gui_elements: Control = $GUI_Elements
@onready var red_layer: ColorRect = $RedLayer
@onready var loading_progress_bar: ProgressBar = $GUI_Elements/Infos/LoadingProgressBar

func _ready() -> void:
	red_layer.hide()
	player_rendered.hide()
	
	loading_progress_bar.value = 0.0
	progress_loading()
	
	await get_tree().create_timer(11.5).timeout
	dev_intro_ended.emit()
	
	gui_elements.hide()
	player_rendered.show()
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	await get_tree().create_timer(0.1).timeout
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED , true)
	
	var static_tv_shader_material: ShaderMaterial = static_tv_shader.material
	static_tv_shader_material.set_shader_parameter("amount", 350)
	static_tv_shader_material.set_shader_parameter("time_speed", 5)
	static_tv_shader.material = static_tv_shader_material
	
	static_tv_shader.color = Color(1.0, 1.0, 1.0)
	red_layer.show()
	
	audio_stream_player.volume_db = 150
	audio_stream_player.play()
	
	await get_tree().create_timer(0.5).timeout
	audio_stream_player.stop()
	#OS.shell_open("https://www.youtube.com/watch?v=XqZsoesa55w")
	call_deferred("queue_free")

func progress_loading() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(loading_progress_bar, "value", 100, 11.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
