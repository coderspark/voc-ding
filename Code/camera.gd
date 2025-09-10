extends Node2D

var camera_speed := 4	
var right_clicked = false
var start_pos : Vector2
func _physics_process(delta: float) -> void:
	if right_clicked:
		position = start_pos - get_local_mouse_position()
	#position += (Vector2(Input.get_axis("left","right"),Input.get_axis("up","down")) * (Vector2(1,1) / $Camera.zoom)) * camera_speed

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			$Camera.zoom *= 0.9
			if $Camera.zoom.x < 0.5:
				$Camera.zoom = Vector2(0.5,0.5)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$Camera.zoom *= 1.1
			if $Camera.zoom.x > 15:
				$Camera.zoom = Vector2(15,15)
		if event.is_action("move_camera") and event.is_pressed():
			right_clicked = true
			start_pos = position + get_local_mouse_position()
		if event.is_action("move_camera") and event.is_released():
			right_clicked = false
