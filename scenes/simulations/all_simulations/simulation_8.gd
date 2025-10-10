extends Node3D

@onready var camera_3d: Camera3D = $Camera3D
@onready var c_text_label: Label = $CanvasLayer/CTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var city_render: Node3D = $CityRender
@onready var cover: ColorRect = $CanvasLayer/Cover
@onready var static_tv_shader: ColorRect = $CanvasLayer/StaticTVShader
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var credits_label: RichTextLabel = $CanvasLayer/CreditsLabel

var c_text_lines: Array[String] = [
	"This is where we live,",
	"inside this complex,",
	"all stuck inside, without being able to exit.",
	"We sleep, eat, shop, study, and work inside.",
	"it's to dangerous outside, so we are monitored.",
	"We live with the fear of die,",
	"and with the fear of being juged and locked",
	"because we are going against the law.",
	"'It's to protect us' they say,",
	"'to keep the last piece of Hoyploma's citizens alive.'",
	"The new generation, the after the war one.",
	"We cannot protest, while our brothers are dying.",
	"The voluntiers on the battlefield,",
	"and all theses innocent souls left behind us.",
	"But you don't know what I am talking about.",
	"As, we, live in fear.",
	"You live in a unknow paradise, underground.",
	"Why do I talk about that anyways...",
	"I am far from this fear, like all of you,",
	"in a place where I can protest against this damn leader.",
	"The same one that is actually smoking on his private island.",
	"And the more this madness contines, the more the survivor's anger will grow.",
	"[END]",
	"But you are will never experience what is going on here,",
	"you will never make your way into this 'city of last hope' alive."
]

func _ready() -> void:
	city_render.show()
	cover.show()
	static_tv_shader.show()
	await get_tree().create_timer(5.5).timeout
	cover.hide()
	audio_stream_player.stop()
	audio_stream_player.stream = load("res://assets/musics/cold-wind-ambience-404245.mp3")
	audio_stream_player.pitch_scale = 0.5
	audio_stream_player.play()
	await get_tree().create_timer(0.5).timeout
	static_tv_shader.hide()
	animation_player.play("move_camera")
	animation_player.speed_scale = 1.0
	for c_line: String in c_text_lines:
		if not c_line == "[END]":
			c_text_label.text = c_line
			await get_tree().create_timer(c_line.length() / 6).timeout
		else:
			cover.show()
			audio_stream_player.stop()
	c_text_label.text = ""
	await get_tree().create_timer(2.5).timeout
	audio_stream_player.stream = load("res://assets/musics/775441_Limbo.mp3")
	audio_stream_player.play(15.0)
	start_credits()
	
	#await get_tree().create_timer(2.5).timeout
	#get_tree().change_scene_to_file("res://scenes/end_scene/end_scene.tscn")

func start_credits() -> void:
	credits_label.position.y -= 7.0
	await get_tree().create_timer(0.4).timeout
	if credits_label.position.y >= -1404.0:
		start_credits()
	else:
		get_tree().quit()
