extends StaticBody3D
class_name SimulationLeaver

signal leave_simulation

@onready var computer_screen: MeshInstance3D = $Computer/Screen

@export_range(1, 1) var next_simulation_id: int = 1

var player: Player = null

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body

func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player = null

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_E):
		if player and player.detect_collisions():
			leave_simulation.emit()

func _process(_delta: float) -> void:
	update()
	await get_tree().create_timer(7.0).timeout

func update() -> void:
	var img = get_viewport().get_texture().get_image()
	var tex: ImageTexture = ImageTexture.create_from_image(img)
	var mat: StandardMaterial3D = computer_screen.get_surface_override_material(0)
	mat.albedo_texture = tex
	computer_screen.set_surface_override_material(0, mat)
