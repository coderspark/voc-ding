extends CharacterBody2D

var speed = 100

func _ready() -> void:
	$Navigation.target_position = Vector2(100,-200)

func _process(delta: float) -> void:
	var dir = to_local($Navigation.get_next_path_position()).normalized()
	velocity = dir * 1100 * delta
	if dir.x >= 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	move_and_slide()
