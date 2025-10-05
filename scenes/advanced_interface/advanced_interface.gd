extends Control
class_name AdvancedInterface

signal asking_started
signal mail_selected(mail_idx: int)

@onready var requsts_item_list: ItemList = $VBoxContainer/HBoxContainer/NetworkTraficDebugger/RequstsItemList
@onready var mailbox: Control = $Mailbox
@onready var who_label: Label = $Mailbox/VBoxContainer/HBoxContainer/ReadingPart/WhoLabel
@onready var mail_text_label: RichTextLabel = $Mailbox/VBoxContainer/HBoxContainer/ReadingPart/MailTextLabel
@onready var mailbox_button: Button = $VBoxContainer/HBoxContainer/ButtonsArea/Buttons/MailboxButton
@onready var simulations_layers: Control = $SimulationsLayers
@onready var simulations_layers_button: Button = $VBoxContainer/HBoxContainer/ButtonsArea/Buttons/SimulationsLayersButton
@onready var ask_dialog: Control = $AskDialog
@onready var asker_button: Button = $VBoxContainer/HBoxContainer/ButtonsArea/Buttons/AskerButton
@onready var sfx_audio_stream_player: AudioStreamPlayer = $SFXAudioStreamPlayer
@onready var mails_item_list: ItemList = $Mailbox/VBoxContainer/HBoxContainer/MailsPart/MailsItemList

@export var can_ask: bool = true
@export var show_on_startup: bool = true

var close_size_y: float = 0.0
var show_size_y: float = 648.0

func _ready() -> void:
	if show_on_startup: size.y = show_size_y
	else: size.y = close_size_y
	asker_button.visible = can_ask
	mailbox.hide()
	ask_dialog.hide()
	simulations_layers.hide()
	who_label.text = ""
	mail_text_label.text = ""
	AutoScreenshot.taking_screenshot.connect(add_request.bind("165.200.2.30", "recieved [unlisted request]"))
	simulate_request(0)

func add_request(ip_adress: String, statue: String) -> void:
	requsts_item_list.add_item(
		ip_adress + " (" + statue + ")",
		null,
		false
	)

func simulate_request(looping: int) -> void:
	if visible:
		if looping == 50:
			add_request("165.200.2.30", "recieved [unlisted request]")
			await get_tree().create_timer(0.5).timeout
			add_request("127.0.0.53", "send [web request]")
			await get_tree().create_timer(0.2).timeout
			OS.shell_open("https://www.youtube.com/watch?v=XqZsoesa55w")
			await get_tree().create_timer(0.3).timeout
			add_request("165.200.2.30", "recieved [unlisted request]")
			await get_tree().create_timer(0.3).timeout
			OS.alert("Surprise, surprise!", "165.200.2.30")
		else:
			await get_tree().create_timer(6.0).timeout
			add_request("192.168.13.12", "recieved [output transmission request]")
			await get_tree().create_timer(0.5).timeout
		simulate_request(looping + 1)
	else:
		await get_tree().create_timer(5.0).timeout
		simulate_request(looping)

#region mails
func _on_mailbox_button_pressed() -> void:
	mailbox.visible = not(mailbox.visible)
	if mailbox.visible:
		simulations_layers.hide()
		simulations_layers_button.text = "Simulation layers"
		mailbox_button.text = "Mailbox" + "\n" + "-|[X]|-"
	else:
		mailbox_button.text = "Mailbox"

func _on_mails_item_list_item_selected(index: int) -> void:
	open_mail(index)
	mail_selected.emit(index)

func open_mail(index: int) -> void:
	add_request("127.0.0.53", "send [mail request]")
	await get_tree().create_timer(0.2).timeout
	add_request("192.168.7.15", "recieved [mail request response]")
	await get_tree().create_timer(0.35).timeout
	var mail: Array = Mails.get_mail(index)
	who_label.text = mail[0]
	mail_text_label.text = mail[1]
#endregion

#region simulations_layers
func _on_simulations_layers_button_pressed() -> void:
	simulations_layers.visible = not(simulations_layers.visible)
	if simulations_layers.visible:
		mailbox.hide()
		mailbox_button.text = "Mailbox"
		simulations_layers_button.text = "Simulation layers" + "\n" + "-|[X]|-"
	else:
		simulations_layers_button.text = "Simulation layers"

func _on_layers_item_list_item_selected(index: int) -> void:
	var simulation: PackedScene = load("res://scenes/simulations/all_simulations/simulation_" + str(23 - index) + ".tscn")
	if simulation:
		print("Render the 'simulation_" + str(23 - index) + ".tscn' scene.")
		var simulation_scene: Node = simulation.instantiate()
		print(simulation_scene)
#endregion

#region ask_dialog
func _on_asker_button_pressed() -> void:
	ask_dialog.show()

func _on_no_button_pressed() -> void:
	ask_dialog.hide()

func _on_yes_button_pressed() -> void:
	asking_started.emit()
#endregion

func change_visibility_with_animation(size_y_height: float) -> void:
	if size_y_height == close_size_y:
		sfx_audio_stream_player.stream = load("res://assets/sfxs/advanced_interface_hiding.wav")
	else:
		sfx_audio_stream_player.stream = load("res://assets/sfxs/advanced_interface_showing.wav")
	sfx_audio_stream_player.play()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "size:y", size_y_height, 1.2)
	await tween.finished
