extends Control

@onready var talk_label: Label = $TalkLabel

var first_talk_lines: Array[String] = [
	"Greatings [REACTED],",
	"I'il be direct with you.",
	"I know WHO you are, and",
	"you don't know WHO am I.",
	"But you know your current condition,",
	"so you should consider to cooperate.",
	"I have some questions to ask, and you will give me the answers I want.",
	"And don't lie, as the rules are."
]

func _ready() -> void:
	await first_lines()
	OS.alert(
		"You have been disconnected from the Output Display Server, beacuse too many clients are connected." + "\n" + "However you will be reconnected as a'Forced client', which will activate the network trafic debugger and show the advanced interface." + "\n" + "Being a Forced client will take the connection of a non-forced client.",
		"Wake Up.exe"
	)

func first_lines() -> void:
	for line: String in first_talk_lines:
		talk_label.text = line
		await get_tree().create_timer(line.length()/87).timeout
	talk_label.text = ""
