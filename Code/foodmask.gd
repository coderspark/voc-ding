extends Node2D

func _process(_delta: float) -> void:
	position.y = (40 - $"../..".food) / (40/17) - 17
	$"../../Label".text = str($"../..".food)
	print($"../..".food)
