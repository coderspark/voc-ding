extends Node2D

func _process(delta: float) -> void:
	position += Vector2(Input.get_axis("left","right"),Input.get_axis("up","down"))
