extends StaticBody3D

@onready var key_indicator_label: Label3D = $KeyIndicatorLabel

var player: Player = null

func open_door() -> void:
	for _loop in range(20):
		$ActualDoor/Marker3D.rotate_y(deg_to_rad(130/20))
		await get_tree().create_timer(0.1).timeout

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_E):
		if player and player.detect_collisions():
			open_door()


func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
		key_indicator_label.show()

func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player = null
		key_indicator_label.hide()
