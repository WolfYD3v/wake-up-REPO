extends Node3D
class_name Simulation

@onready var player: Player = $Player
@onready var begin_texts_label: Label = $GUI/Control/BeginTextsLabel
@onready var gui: CanvasLayer = $GUI

@export var begin_texts: Array[String] = []

func _ready() -> void:
	player.can_move = false
	player.can_rotate = false
	gui.show()
	for begin_text: String in begin_texts:
		begin_texts_label.text = begin_text
		await get_tree().create_timer(begin_text.length() / 3).timeout
	gui.hide()
	player.can_move = true
	player.can_rotate = true

func change_simulation_layer() -> void:
	player.can_move = false
	player.can_rotate = false
	player.player_camera.fov = 15.0
	await get_tree().create_timer(1.5).timeout
	get_tree().quit()

func _on_simulation_leaver_leave_simulation() -> void:
	change_simulation_layer()
