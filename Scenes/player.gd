extends CharacterBody2D

var speed = 100
var offset = 0

func _ready() -> void:
	$Navigation.target_position = position

func _process(delta: float) -> void:
	offset += 0.1
	var dir = to_local($Navigation.get_next_path_position()).normalized()
	velocity = dir * 1100 * delta + Vector2(0, cos(offset)) * 25
	if dir.x >= 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	move_and_slide()


func _on_terrain_click(pos:Vector2) -> void:
	$Navigation.target_position = pos
