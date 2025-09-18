extends CharacterBody3D
class_name Player

@onready var player_camera: Camera3D = $PlayerCamera
@onready var collision_raycast: RayCast3D = $CollisionRaycast

var y_rotation_factor: float = 90.0
var rotation_steps: int = 10
var is_rotating: bool = false

var z_move_factor: float = 25.0
var walk_steps: int = 20
var is_moving: bool = false

func _detect_collisions() -> bool:
	return collision_raycast.is_colliding()

func _rotate(rotation_factor: float) -> void:
	if not is_rotating:
		is_rotating = true
		for rot_step: int in range(rotation_steps):
			rotate_y(deg_to_rad(rotation_factor/rotation_steps))
			await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(0.3).timeout
		is_rotating = false

func _move(move_factor: float) -> void:
	if not _detect_collisions():
		if not is_moving:
			is_moving = true
			var angle = get_rotation().y 
			for move_step: int in range(walk_steps):
				velocity = Vector3(sin(angle),0, cos(angle)) * move_factor / walk_steps
				move_and_slide()
				await get_tree().create_timer(0.05).timeout
			await get_tree().create_timer(0.2).timeout
			is_moving = false

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_LEFT):
		_rotate(y_rotation_factor)
	if Input.is_key_pressed(KEY_RIGHT):
		_rotate(-y_rotation_factor)
	if Input.is_key_pressed(KEY_UP):
		_move(-z_move_factor)
