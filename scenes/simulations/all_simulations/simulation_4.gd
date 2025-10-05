extends Control

signal keyboard_input_done
signal end_simulation

@onready var questions: ItemList = $Areas/QuestionningSection/Questions
@onready var chat: VBoxContainer = $Areas/ChatSection/Chat
@onready var timer_label: Label = $Areas/QuestionningSection/DownArea/TimerLabel
@onready var users: VBoxContainer = $Areas/QuestionningSection/DownArea/Users
@onready var sfx_audio_stream_player: AudioStreamPlayer = $SFXAudioStreamPlayer
@onready var down_area: VBoxContainer = $Areas/QuestionningSection/DownArea
@onready var areas: HBoxContainer = $Areas
@onready var loading: ColorRect = $Loading
@onready var loading_state_label: Label = $Loading/LoadingStateLabel
@onready var advanced_interface: AdvancedInterface = $AdvancedInterface

var a_answers: Array[String] = [
	"Somewhere where he can be free."
]
var dialog_text_positions_as_who: Dictionary = {
	"You": HORIZONTAL_ALIGNMENT_LEFT,
	"John": HORIZONTAL_ALIGNMENT_LEFT,
	"#53981": HORIZONTAL_ALIGNMENT_RIGHT
}

var timer: float = 0.0
var wait_time_timer: float = 1.0

func a() -> void:
	pass

func _ready() -> void:
	Mails.add_mail("John", "He didn't talk, but he has give some tasty informations." + "\n" + "So there is somewhere where the is no war. And the target is hiding there too." + "\n" + "\n" + "I should tell our Boss about this, we will capture this monkey and close this case. And move all our citizens in this place, free and happy again." + "\n" + "\n" + "Thanks for your services, see you later at the coffee machine!")
	advanced_interface.mails_item_list.add_item("Talk report #3", null, true)
	advanced_interface.mails_item_list.move_item(Mails.mails_count, 0)
	down_area.hide()
	users.hide()
	questions.hide()
	chat.hide()
	areas.hide()
	loading.hide()
	loading_state_label.text = "LOADING..."
	await get_tree().create_timer(1.0).timeout
	loading.show()
	await get_tree().create_timer(0.5).timeout
	areas.show()
	await get_tree().create_timer(0.2).timeout
	down_area.show()
	await get_tree().create_timer(0.3).timeout
	users.show()
	await get_tree().create_timer(0.1).timeout
	add_user("Jade")
	await get_tree().create_timer(0.1).timeout
	add_user("#53981")
	await get_tree().create_timer(0.2).timeout
	questions.show()
	chat.show()
	loading_state_label.text = "READY"
	await get_tree().create_timer(0.4).timeout
	loading_state_label.text = "GOOD LUCK"
	await get_tree().create_timer(0.6).timeout
	loading.hide()
	up_timer()
	await end_simulation
	await get_tree().create_timer(3.5).timeout
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
	await get_tree().create_timer(0.05).timeout
	advanced_interface.hide()
	areas.hide()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	await get_tree().create_timer(0.02).timeout
	AutoDownload.start_auto_download()
	await get_tree().create_timer(0.02).timeout
	get_tree().change_scene_to_file("res://scenes/simulations/all_simulations/simulation_5.tscn")

func up_timer() -> void:
	timer_label.text = str(timer) + "s"
	await get_tree().create_timer(wait_time_timer).timeout
	timer += wait_time_timer
	up_timer()

func _on_questions_item_selected(index: int) -> void:
	questions.hide()
	sfx_audio_stream_player.stream = load("res://assets/sfxs/button_hover.wav")
	sfx_audio_stream_player.play()
	await get_tree().create_timer(0.5).timeout
	await add_text_to_chat("You", questions.get_item_text(index), load("res://assets/sfxs/button_hover.wav"))
	await get_tree().create_timer(1.0).timeout
	if a_answers[index] == "[j_time]":
		add_user("John")
		await add_text_to_chat("John", "He is crazy, stop this nonsence here. I can't take this anymore.", load("res://assets/sfxs/b_answer.wav"))
		areas.hide()
		await advanced_interface.change_visibility_with_animation(advanced_interface.show_size_y)
		print("ee")
	if a_answers[index] != "":
		await add_text_to_chat("#53981", a_answers[index], load("res://assets/sfxs/b_answer.wav"))
	dialog_events_management(a_answers[index])
	if questions.item_count >= index + 1:
		remove_question(index)
	questions.show()

func remove_question(index: int) -> void:
	a_answers.remove_at(index)
	questions.remove_item(index)

func add_question(question: String, answer: String) -> void:
	questions.add_item(question, null, true)
	a_answers.append(answer)

func add_text_to_chat(as_who: String, msg_content: String, text_sfx_stream: AudioStream) -> void:
	var msg_rich_text_label: RichTextLabel = RichTextLabel.new()
	chat.add_child(msg_rich_text_label)
	msg_rich_text_label.fit_content = true
	msg_rich_text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	msg_rich_text_label.horizontal_alignment = dialog_text_positions_as_who.get(as_who)
	msg_rich_text_label.bbcode_enabled = true
	msg_rich_text_label.custom_minimum_size.y = 30
	var msg_text: String = ""
	var words: Array[String] = segmentagisement_text_as_array(msg_content)
	await get_tree().create_timer(0.05).timeout
	msg_rich_text_label.text = "[color=black][u][b]" + as_who + ":[/b][/u] " + msg_text + "[/color]"
	for word: String in words:
		if as_who == "You":
			await keyboard_input_done
		msg_text += word
		msg_rich_text_label.text = "[color=black][u][b]" + as_who + ":[/b][/u] " + msg_text + "[/color]"
		sfx_audio_stream_player.stream = text_sfx_stream
		sfx_audio_stream_player.play()
		if not as_who == "You":
			await get_tree().create_timer(randf_range(0.05, 0.12)).timeout

func segmentagisement_text_as_array(text: String) -> Array[String]:
	var text_as_array: Array[String] = []
	var word: String = ""
	for text_character: String in text:
		word += text_character
		if text_character in [" ", ".", ",", "!", "?", ";", ":"]:
			text_as_array.append(word)
			word = ""
	return text_as_array

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		keyboard_input_done.emit()

func dialog_events_management(answer: String) -> void:
	match answer:
		"Somewhere where he can be free.":
			add_question("Where is this place of freedom?", "I won't tell.")
			add_question("You know there is nowhere of Earth someone can be free right?", "This is why I won't tell where he is.")
		"This is why I won't tell where he is.":
			questions.clear()
			a_answers.clear()
			await get_tree().create_timer(0.1).timeout
			add_question("I get it, I get it...", "")
		"":
			add_question("Was was your motivation when you commited this crime?", "I wasn't a crime, it was the expression of the citizen's anger.")
		"I wasn't a crime, it was the expression of the citizen's anger.":
			add_question("What anger... I mean they don't seems to complain.", "Because they can't complain. We don't have ANY freedom in this country!")
		"Because they can't complain. We don't have ANY freedom in this country!":
			add_question("Our society is falling apart while the war continues. And to protect the next generation that will rebuild the world we have to limit their freedom in exchange of their protection.", "You have to, like if this is THE solution.")
		"You have to, like if this is THE solution.":
			add_question("What else can we do! Tell me, what else can we do!", "Hoyploma is done, but you all know a place that will protect everyone, and let them free. This is why he and I we have protested!")
		"Hoyploma is done, but you all know a place that will protect everyone, and let them free. This is why he and I we have protested!":
			add_question("Protesting is absolutely forbidden, and... and how can you forgive someone who let you down?", "I will be honnest, if HE was shot, I would run away too. So I can't be angry and hate him.")
		"I will be honnest, if HE was shot, I would run away too. So I can't be angry and hate him.":
			add_question("So this is why you aren't cooporating with us.", "[j_time]")

func add_user(username: String) -> void:
	var user_area: HBoxContainer = HBoxContainer.new()
	user_area.name = username
	var square: ColorRect = ColorRect.new()
	square.custom_minimum_size = Vector2(20, 20)
	square.color = Color(0.278, 0.604, 0.0)
	user_area.add_child(square)
	var user_label: Label = Label.new()
	user_label.name = username + "Label"
	user_label.text = username
	user_label.add_theme_color_override("font_color", Color(0.278, 0.604, 0.0))
	user_area.add_child(user_label)
	users.add_child(user_area)


func _on_advanced_interface_mail_selected(mail_idx: int) -> void:
	if mail_idx == 0:
		end_simulation.emit()
