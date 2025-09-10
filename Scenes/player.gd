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
	$Label.text = "FPS: " + str(1/delta)
	if Input.is_action_just_pressed("left"):
		if on_water:
			go_on_land()
		else:
			go_on_water()
	if move:
		var dir = to_local($Navigation.get_next_path_position()).normalized()
		velocity = dir * 1100 * delta
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
		if n in out.keys():
			out.set(n,0)
		for x in  $"../Fog".get_surrounding_cells(n):
			if x in out.keys():
				out.set(x,0)
			for y in  $"../Fog".get_surrounding_cells(x):
				if not y in out.keys():
					out.set(y,1)
	return out

func go_on_land():
	for n in $"../Terrain".get_surrounding_cells($"../Terrain".local_to_map(position)):
		if $"../Terrain".get_cell_atlas_coords(n) not in Global.water_types:
			position = $"../Terrain".map_to_local(n)
			$Sprite.play("land")
			on_water = false
			move = false
			$Navigation.navigation_layers = 2
			return 1
	return 0
		
func go_on_water():
	for n in $"../Terrain".get_surrounding_cells($"../Terrain".local_to_map(position)):
		if $"../Terrain".get_cell_atlas_coords(n) in Global.water_types:
			position = $"../Terrain".map_to_local(n)	
			$Navigation.navigation_layers = 4
			$Sprite.play("water")
			on_water = true
			move = false
			return 1
	return 0
