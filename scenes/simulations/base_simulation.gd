extends Node3D
class_name Simulation

@onready var player: Player = $Player
@onready var begin_texts_label: Label = $GUI/BeginTexts/BeginTextsLabel
@onready var begin_texts_section: Control = $GUI/BeginTexts
@onready var simulation_leaver: SimulationLeaver = $SimulationLeaver
@onready var questioning_scene: QuestioningScene = $GUI/QuestioningScene

@export var begin_texts: Array[String] = []

var tween

func _ready() -> void:
	player.can_move = false
	player.can_rotate = false
	begin_texts_section.show()
	for begin_text: String in begin_texts:
		begin_texts_label.text = begin_text
		await get_tree().create_timer(begin_text.length() / 10).timeout
	begin_texts_section.hide()
	player.can_move = true
	player.can_rotate = true
	InputsLogger.enable_auto_inputs_logging()

func change_simulation_layer() -> void:
	player.can_move = false
	player.can_rotate = false
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(player.player_camera, "fov", 145.0, 4.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	InputsLogger.disable_auto_inputs_logging()
	InputsLogger.save_inputs_as_file()
	await get_tree().create_timer(4.0).timeout
	questioning_scene.show()
	questioning_scene.start_questioning()
	await questioning_scene.questioning_ended
	get_tree().change_scene_to_file("res://scenes/simulations/all_simulations/simulation_1.tscn")

func _on_simulation_leaver_leave_simulation() -> void:
	change_simulation_layer()
