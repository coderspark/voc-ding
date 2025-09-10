extends CharacterBody2D

var speed = 100

var on_water = true
var move = false
var target : Vector2

var old_dir_x = 0

func _ready() -> void:
	$Navigation.target_position = position
	var a = get_cells_around_player($"../Fog".local_to_map(global_position))
	for cell in a.keys():
		if a[cell] == 0:
			$"../Fog".erase_cell(cell)
		elif not $"../Fog".get_cell_atlas_coords(cell) == Vector2i(-1,-1):
			$"../Fog".set_cell(cell,0,Vector2i(15,1))

func _process(delta: float) -> void:
	if move:
		var dir = to_local($Navigation.get_next_path_position()).normalized()
		velocity = dir * 1100 * delta
		print(dir.x)
		if dir.x > 0:
			if dir.x * old_dir_x > 0:
				$Sprite.flip_h = true
		else:
			if dir.x * old_dir_x > 0:
				$Sprite.flip_h = false
		old_dir_x = dir.x
		move_and_slide()
		var a = get_cells_around_player($"../Fog".local_to_map(global_position))
		for cell in a.keys():
			if a[cell] == 0:
				$"../Fog".erase_cell(cell)
			elif not $"../Fog".get_cell_atlas_coords(cell) == Vector2i(-1,-1):
				$"../Fog".set_cell(cell,0,Vector2i(15,1))
func _on_terrain_click(pos:Vector2) -> void:
	$Navigation.target_position = pos
	target = pos
	move = true

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


func _on_navigation_target_reached() -> void:
	if move:
		print($Navigation.distance_to_target() * 0.07)
		$Timer.start($Navigation.distance_to_target() * 0.07)
		await $Timer.timeout
		print("stop")
		move = false
