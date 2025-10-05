extends Node3D
class_name QuestioningScene

signal next_question
signal questioning_ended

@onready var question_label: Label = $GUI/Elements/QuestionLabel
@onready var buttons: HBoxContainer = $GUI/Elements/Buttons
@onready var sfx_audio_stream_player: AudioStreamPlayer = $SFXAudioStreamPlayer
@onready var static_tv_shader: ColorRect = $GUI/StaticTVShader
@onready var filler: ColorRect = $GUI/Filler

@export var questions: Array[Question]

func _ready() -> void:
	question_label.text = ""
	buttons.hide()
	filler.hide()
	static_tv_shader.hide()

func start_questioning() -> void:
	if not questions.is_empty():
		static_tv_shader.show()
		play_sfx("res://assets/musics/775441_Limbo.mp3", 25.0, 1.0)
		await get_tree().create_timer(1.5).timeout
		sfx_audio_stream_player.stop()
		static_tv_shader.hide()
		start_questioning()
		play_sfx("res://assets/musics/775441_Limbo.mp3", 25.0, 1.0)
		sfx_audio_stream_player.stream_paused = false
		for question: Question in questions:
			static_tv_shader.hide()
			_clear_buttons()
			question_label.text = question.question
			sfx_audio_stream_player.stream_paused = false
			play_sfx("res://assets/sfxs/questionning.wav", 0.0, 0.4)
			await get_tree().create_timer(0.3).timeout
			buttons.show()
			if not question.bad_answers.is_empty():
				_create_buttons([question.good_answer] + [question.bad_answers])
			else:
				_create_buttons([question.good_answer])
			await next_question
			question_label.text = ""
			buttons.hide()
			static_tv_shader.show()
			await get_tree().create_timer(2.0).timeout
			sfx_audio_stream_player.stream_paused = true
		sfx_audio_stream_player.stream_paused = false
		filler.show()
		await get_tree().create_timer(5.0).timeout
		questioning_ended.emit()

func _create_buttons(buttons_to_create: Array) -> void:
	var good_answer_text: String = buttons_to_create[0]
	var bad_answers: Array[String]
	if buttons_to_create.size() > 1:
		bad_answers = buttons_to_create[1]
	
	var good_answer_button: Button = Button.new()
	buttons.add_child(good_answer_button)
	play_sfx("res://assets/sfxs/questionning.wav", 0.0, 1.0)
	good_answer_button.text = good_answer_text
	good_answer_button.pressed.connect(_good_answer_clicked)
	await sfx_audio_stream_player.finished
	
	if not bad_answers.is_empty():
		for bad_answer_text: String in bad_answers:
			var bad_answer_button: Button = Button.new()
			buttons.add_child(bad_answer_button)
			play_sfx("res://assets/sfxs/questionning.wav", 0.0, 1.0)
			bad_answer_button.text = bad_answer_text
			bad_answer_button.pressed.connect(_bad_answer_clicked)
			await sfx_audio_stream_player.finished

func play_sfx(sfx_path: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	sfx_audio_stream_player.stream = load(sfx_path)
	sfx_audio_stream_player.volume_db = volume_db
	sfx_audio_stream_player.pitch_scale = pitch_scale
	sfx_audio_stream_player.play()

func _clear_buttons() -> void:
	for button: Button in buttons.get_children():
		button.queue_free()

func _good_answer_clicked() -> void:
	play_sfx("res://assets/sfxs/questionning.wav", 0.0, 2.25)
	await sfx_audio_stream_player.finished
	next_question.emit()

func _bad_answer_clicked() -> void:
	play_sfx("res://assets/sfxs/questionning.wav", 0.0, 2.25)
	await sfx_audio_stream_player.finished
	next_question.emit()
