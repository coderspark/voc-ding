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
	var a = get_cells_around_player($"../Fog".local_to_map(global_position))
	for cell in a.keys():
		print(a[cell])
		if a[cell] == 0:
			$"../Fog".erase_cell(cell)
		elif not $"../Fog".get_cell_atlas_coords(cell) == Vector2i(-1,-1):
			$"../Fog".set_cell(cell,0,Vector2i(15,1))
func _on_terrain_click(pos:Vector2) -> void:
	$Navigation.target_position = pos

func get_cells_around_player(pos:Vector2i):
	var out = {}
	for n in $"../Fog".get_surrounding_cells(pos):
		out.set(n,0)
		for x in  $"../Fog".get_surrounding_cells(n):
			out.set(x,0)
			for y in  $"../Fog".get_surrounding_cells(x):
				if not y in out:
					out.set(y,1)
	return out
