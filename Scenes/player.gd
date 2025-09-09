extends CharacterBody2D

var speed = 100

func _ready() -> void:
	$Navigation.target_position = position

func _process(delta: float) -> void:
	var dir = to_local($Navigation.get_next_path_position()).normalized()
	velocity = dir * 1100 * delta
	if dir.x >= 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	move_and_slide()
	for cell in get_cells_around_player($"../Fog".local_to_map(global_position)):
		$"../Fog".erase_cell(cell)
	


func _on_terrain_click(pos:Vector2) -> void:
	$Navigation.target_position = pos

func get_cells_around_player(pos:Vector2i):
	var out = []
	for n in $"../Fog".get_surrounding_cells(pos):
		for x in  $"../Fog".get_surrounding_cells(n):
			for y in  $"../Fog".get_surrounding_cells(x):
				if not y in out:
					out.append(y)
	return out
