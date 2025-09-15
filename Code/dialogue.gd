extends Control

var Character_mappings = {
	"Bert":Vector2(0,0),
	"Mary":Vector2(0,1),
	"Gerald":Vector2(0,2),
	"Drgehaktbal01":Vector2(0,3),
}

func show_dialogue(data:Array):
	print("hey")
	$CanvasLayer/Control.show()
	for n in data:
		$CanvasLayer/Control/Text.text = ""
		$"CanvasLayer/Control/Character name".text = n[1]
		$CanvasLayer/Control/Character.region_rect.position.y = Character_mappings[n[1]].y * 16
		for char in n[0]:
			$Timer.start(0.03)
			await $Timer.timeout
			$CanvasLayer/Control/Text.text += char
		$Timer.start(1)
		await $Timer.timeout
	$CanvasLayer/Control.hide()

func _ready() -> void:
	show_dialogue([
		["hey!","Mary"],["hey!","Bert"],["Do you want to see my trade offer?","Mary"],["Yeah, sure!","Bert"],
		["tim","Drgehaktbal01"],
	])
