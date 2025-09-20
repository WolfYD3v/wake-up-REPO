extends StaticBody3D

signal leave_simulation

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
