extends Node3D
class_name Simulation

@onready var player: Player = $Player
@onready var begin_texts_label: Label = $GUI/BeginTexts/BeginTextsLabel
@onready var begin_texts_section: Control = $GUI/BeginTexts
@onready var simulation_leaver: SimulationLeaver = $SimulationLeaver
@onready var questioning_scene: QuestioningScene = $GUI/QuestioningScene
@onready var button_sfx_audio_stream_player: AudioStreamPlayer = $ButtonSFXAudioStreamPlayer
@onready var ambiance_audio_stream_player: AudioStreamPlayer = $AmbianceAudioStreamPlayer
@onready var advanced_interface: AdvancedInterface = $GUI/AdvancedInterface

@export_range(1, 8) var next_simulation_id: int = 1
@export var begin_texts: Array[String] = []
@export var questionning_scene_questions: Array[Question] = []

var tween

func _ready() -> void:
	questioning_scene.questions = questionning_scene_questions
	advanced_interface.visible = Settings.advanced_interface_visibility
	player.can_move = false
	player.can_rotate = false
	begin_texts_section.show()
	for begin_text: String in begin_texts:
		begin_texts_label.text = begin_text
		play_sfx("res://assets/sfxs/text.wav", 0.0, 1.0)
		await get_tree().create_timer(begin_text.length() / 10).timeout
	begin_texts_section.hide()
	player.can_move = true
	player.can_rotate = true
	InputsLogger.enable_auto_inputs_logging()

func change_simulation_layer() -> void:
	InputsLogger.disable_auto_inputs_logging()
	player.can_move = false
	player.can_rotate = false
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(player.player_camera, "fov", 145.0, 4.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	play_sfx("res://assets/sfxs/change_level.wav", 10.0, 0.2)
	await tween.finished
	button_sfx_audio_stream_player.stop()
	await get_tree().create_timer(4.0).timeout
	ambiance_audio_stream_player.stop()
	questioning_scene.show()
	questioning_scene.start_questioning()
	await questioning_scene.questioning_ended
	get_tree().change_scene_to_file("res://scenes/simulations/all_simulations/simulation_" + str(next_simulation_id) + ".tscn")

func _on_simulation_leaver_leave_simulation() -> void:
	change_simulation_layer()

func play_sfx(sfx_path: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	button_sfx_audio_stream_player.volume_db = volume_db
	if pitch_scale != 1.0:
		button_sfx_audio_stream_player.pitch_scale = randf_range(0.6, 0.8)
	button_sfx_audio_stream_player.stream = load(sfx_path)
	button_sfx_audio_stream_player.play()
