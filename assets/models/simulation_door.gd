extends StaticBody3D

@onready var key_indicator_label: Label3D = $KeyIndicatorLabel

var player: Player = null
var is_open: bool = false
var is_active: bool = false


func move_door(move_value: int) -> void:
	if not is_active:
		is_active = true
		set_indicator_text()
		for _loop in range(20):
			$ActualDoor/Marker3D.rotate_y(deg_to_rad(move_value/20))
			await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(0.3).timeout
		is_active = false

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_E):
		if player and player.detect_collisions():
			if not is_open:
				await move_door(130)
				is_open = true
				set_indicator_text()
			else:
				await move_door(-130)
				is_open = false
				set_indicator_text()

func set_indicator_text() -> void:
	if is_active:
		key_indicator_label.text = "Door is doing" + "\n" + "something"
		return
	if not is_open:
		key_indicator_label.text = "E key" + "\n" + "-> Open"
	else:
		key_indicator_label.text = "E key" + "\n" + "-> Close"

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
		set_indicator_text()
		key_indicator_label.show()

func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player = null
		key_indicator_label.hide()
