extends Control
class_name QuestioningScene

signal next_question
signal questioning_ended

@onready var question_label: Label = $Elements/QuestionLabel
@onready var buttons: HBoxContainer = $Elements/Buttons

@export var questions: Array[Question]

func _ready() -> void:
	start_questioning()

func start_questioning() -> void:
	if not questions.is_empty():
		for question: Question in questions:
			_clear_buttons()
			question_label.text = question.question
			if not question.bad_answers.is_empty():
				_create_buttons([question.good_answer] + [question.bad_answers])
			else:
				_create_buttons([question.good_answer])
			await next_question
		questioning_ended.emit()

func _create_buttons(buttons_to_create: Array) -> void:
	print(buttons_to_create)
	var good_answer_text: String = buttons_to_create[0]
	var bad_answers: Array[String]
	if buttons_to_create.size() > 1:
		bad_answers = buttons_to_create[1]
	
	var good_answer_button: Button = Button.new()
	buttons.add_child(good_answer_button)
	good_answer_button.text = good_answer_text
	good_answer_button.pressed.connect(_good_answer_clicked)
	
	if not bad_answers.is_empty():
		for bad_answer_text: String in bad_answers:
			var bad_answer_button: Button = Button.new()
			buttons.add_child(bad_answer_button)
			bad_answer_button.text = bad_answer_text
			bad_answer_button.pressed.connect(_bad_answer_clicked)

func _clear_buttons() -> void:
	for button: Button in buttons.get_children():
		button.queue_free()

func _good_answer_clicked() -> void:
	next_question.emit()

func _bad_answer_clicked() -> void:
	next_question.emit()
