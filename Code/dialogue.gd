extends Control

func show_dialogue(data:Array):
	$CanvasLayer.show()
	for n in data:
		$CanvasLayer/Text.text = ""
		$CanvasLayer/Name.text = n[1]
		for char in n[0]:
			$Timer.start(0.03)
			await $Timer.timeout
			$CanvasLayer/Text.text += char
		$Timer.start(1)
		await $Timer.timeout
	$CanvasLayer.hide()

func _ready() -> void:
	show_dialogue([["hey!","mary"],["hey!","john"],["kill yourself!","mary"],["not if i kill you first!","john"],["I died!","mary"]])
