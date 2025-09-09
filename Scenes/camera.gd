extends Node2D

var camera_speed := 4	

func _process(delta: float) -> void:
	position += (Vector2(Input.get_axis("left","right"),Input.get_axis("up","down")) * (Vector2(1,1) / $Camera.zoom)) * camera_speed

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$Camera.zoom *= 0.9
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			$Camera.zoom *= 1.1
