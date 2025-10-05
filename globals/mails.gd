extends Node

var _mails: Array[Array] = [
	[
		"John",
		"Jade, it's me John." + "\n" + "#53981 is ready to talk, again. We will see if he will tell where this rat is. It's his friend after all, they commited this crime together." + "\n" + "\n"  + "But when he is in danger he prefer run away and not help his injured '''friend'''." + "\n" + "What a shame solidariy is not in human's nature." + "\n" + "\n" + "You can start asking him questions when you are ready. And the IT team try to see who too k your connection with the Output Display Server without being a forced client."
	],
	[
		"Britany",
		"I know you are working, but I invite you in my party." + "\n" + "It starts at 10pm, so feel free to come when you are free ;)"  + "\n" + "\n"  + "Love you babe!!!"
	],
	[
		"John",
		"So Jade he is caught? I hope so." + "\n" + "I mean I don't like what we are doing, do we have to get that far to make him talk? I don't think we have, and you too."  + "\n" + "\n"  + "I got a lot of work to do before 4pm, see you after your hours! We can talk more about that in a café don't yoou think?"
	],
	[
		"John",
		"Hi Jade," + "\n" + "Can you please call the police for me, my phone has run out of battery and we need to capture him quickly."  + "\n" + "\n"  + "Thanks!"
	],
	[
		"Charlie",
		"It seems that #53981's friend has leave Orlando City yesterday." + "\n" + "Can you please call the police for me, my phone has run out of battery and we need to capture him quickly."  + "\n" + "\n"  + "Thanks!"
	],
	[
		"IT team",
		"Hello Jade. John has asked us to tell you about the advanced interface." + "\n" + "We have configured an e-mail client to let you check your mails while you are working. We know turning one your phone can distract you." + "\n" + "But the advanced interface is not enabled by default. You can use you key to enable it by going in the options. Think about that it was NOT an easy task to do, as usual." + "\n" + "\n" + "No need to thanks up, we do what we are paid to do."
	],
	[
		"John",
		"Congrats Jade for your promotion! Do you feel better now?" + "\n" + "Now as an officer your goal is to keep an eye on your criminal. It's the #53981, at the sector 3." + "\n" + "\n" + "I will see you there, with someone from the IT team to let him configure your access to the Display Output Server." + "\n" + "See you later my Dear!"
	],
]
var mails_count = 0

func _ready() -> void:
	mails_count = _mails.size() - 1

func get_mail(index: int) -> Array:
	var mail: Array = _mails.get(index)
	return mail

func add_mail(sender: String, content: String) -> void:
	_mails.insert(0, [sender, content])
	mails_count += 1
