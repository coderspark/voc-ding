extends Node
var food = 40
func _process(_delta: float):
	$"Timer".start(0.1)
	await $"Timer".timeout
	food -= 0.1
