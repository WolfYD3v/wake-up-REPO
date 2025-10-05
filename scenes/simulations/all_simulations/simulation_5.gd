extends Simulation

@onready var blocker_1: Node3D = $Map/Blocker1
@onready var blocker_2: Node3D = $Map/Blocker2
@onready var blocker_3: Node3D = $Map/Blocker3
@onready var blocker_4: Node3D = $Map/Blocker4
@onready var blocker_5: Node3D = $Map/Blocker5

@onready var blocker_1_area_3d: Area3D = $Blocker1Area3D
@onready var blocker_2_area_3d: Area3D = $Blocker2Area3D
@onready var blocker_3_area_3d: Area3D = $Blocker3Area3D
@onready var blocker_4_area_3d: Area3D = $Blocker4Area3D
@onready var change_ambiance_area_3d: Area3D = $ChangeAmbianceArea3D

var max_screenshots: int = 5

func _ready() -> void:
	for screenshot_idx: int in range(1, max_screenshots + 1):
		var screenshot: MeshInstance3D = get_node("Screenshot" + str(screenshot_idx))
		if screenshot:
			var mat: StandardMaterial3D = StandardMaterial3D.new()
			mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
			mat.albedo_texture = AutoScreenshot.get_screenshot()
			screenshot.set_surface_override_material(0, mat)
	advanced_interface.hide()
	begin_texts_section.hide()
	InputsLogger.enable_auto_inputs_logging()

func delete_area_3d(area_3d: Area3D) -> void:
	area_3d.call_deferred("queue_free")

func _on_blocker_1_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		blocker_1.position.x += 2.0
		play_sfx("res://assets/sfxs/sim3_fist_sfx.wav", 0.0, 0.1)
		delete_area_3d(blocker_1_area_3d)

func _on_blocker_2_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		blocker_2.position.x -= 2.0
		play_sfx("res://assets/sfxs/sim3_fist_sfx.wav", 0.0, 0.2)
		delete_area_3d(blocker_2_area_3d)

func _on_blocker_3_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		blocker_3.position.x += 2.0
		play_sfx("res://assets/sfxs/sim3_fist_sfx.wav", 0.0, 0.5)
		delete_area_3d(blocker_3_area_3d)

func _on_blocker_4_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		blocker_4.position.x -= 2.0
		play_sfx("res://assets/sfxs/sim3_fist_sfx.wav", 0.0, 0.9)
		delete_area_3d(blocker_4_area_3d)

func _on_change_ambiance_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		ambiance_audio_stream_player.stop()
		ambiance_audio_stream_player.stream = load("res://assets/musics/775441_Limbo.mp3")
		ambiance_audio_stream_player.play(15.30)
		delete_area_3d(change_ambiance_area_3d)
