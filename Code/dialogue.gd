extends Control

func show_dialogue(text:String,character:String):
	$CanvasLayer/Text.text = ""
	for char in text:
		$Timer.start()
		await $Timer.timeout
		$CanvasLayer/Text.text += char

func _ready() -> void:
	show_dialogue("Hello there, fellow traveler!","Mary")
	show_dialogue("Kill yourself, NOW!","Mary")
