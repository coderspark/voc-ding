extends Control

var Character_mappings = {"Bert":Vector2(0,0),"Mary":Vector2(0,1),"Gerald":Vector2(0,2),}

func show_dialogue(data:Array):
	print("hey")
	$CanvasLayer.show()
	for n in data:
		$CanvasLayer/Text.text = ""
		$"CanvasLayer/Character name".text = n[1]
		$CanvasLayer/Character.region_rect.y = Character_mappings[n[1]]
		for char in n[0]:
			$Timer.start(0.03)
			await $Timer.timeout
			$CanvasLayer/Text.text += char
		$Timer.start(1)
		await $Timer.timeout
	$CanvasLayer.hide()

func _ready() -> void:
	show_dialogue([["hey!","Mary"],["hey!","Bert"],["Do you want to see my trade offer?","Mary"],["Yeah, sure!","Mary"]])
