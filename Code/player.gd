extends CharacterBody2D

var speed = 100

var on_water = true
var move = false
var target : Vector2

var old_dir_x = 0

var fog_relatives = {Vector2i(3, 0): 1,Vector2i(3, 1): 1,Vector2i(2, 1): 0,Vector2i(1, 0): 0,Vector2i(2, -1): 0,Vector2i(3, -1): 1,Vector2i(2, 2): 1,Vector2i(1, 2): 0,Vector2i(1, 1): 0,Vector2i(2, 0): 1,Vector2i(0, 2): 0,Vector2i(0, 1): 0,Vector2i(0, 0): 0,Vector2i(-1, 0): 0,Vector2i(0, -1): 0,Vector2i(1, -1): 0,Vector2i(0, -2): 0,Vector2i(1, -2): 0,Vector2i(2, -2): 1,Vector2i(2, 3): 1,Vector2i(1, 3): 1,Vector2i(0, 3): 1,Vector2i(-1, 2): 0,Vector2i(-1, 1): 0,Vector2i(-1, 3): 1,Vector2i(-2, 2): 1,Vector2i(-2, 1): 1,Vector2i(-2, 0): 0,Vector2i(-1, -1): 0,Vector2i(-3, 0): 1,Vector2i(-2, -1): 1,Vector2i(-2, -2): 1,Vector2i(-1, -2): 0,Vector2i(-1, -3): 1,Vector2i(0, -3): 1,Vector2i(1, -3): 1,Vector2i(2, -3): 1 }


func _ready() -> void:
	$Navigation.target_position = position
	var a = get_cells_around_player($"../Fog".local_to_map(global_position))
	for cell in a.keys():
		if a[cell] == 0:
			$"../Fog".erase_cell(cell)
		elif not $"../Fog".get_cell_atlas_coords(cell) == Vector2i(-1,-1):
			$"../Fog".set_cell(cell,0,Vector2i(15,1))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		if on_water:
			go_on_land()
		else:
			go_on_water()
	if move:
		var dir = to_local($Navigation.get_next_path_position()).normalized()
		velocity = dir * 60
		if dir.x > 0:
			if dir.x * old_dir_x > 0:
				$Sprite.flip_h = true
		else:
			if dir.x * old_dir_x > 0:
				$Sprite.flip_h = false
		old_dir_x = dir.x
		move_and_slide()
		var n = $"../Fog".local_to_map(global_position)
		var a = get_cells_around_player(n)
		for cell in a.keys():
			if a[cell] == 0 and not $"../Fog".get_cell_atlas_coords(cell + n) == Vector2i(-1,-1):
				$"../Fog".erase_cell(cell + n)
			elif not $"../Fog".get_cell_atlas_coords(cell + n) == Vector2i(-1,-1):
				$"../Fog".set_cell(cell + n,0,Vector2i(15,1))
		if position.distance_to($Navigation.get_final_position()) < 0.5:
			move = false
func _on_terrain_click(pos:Vector2) -> void:
	$Navigation.target_position = pos
	target = pos
	move = true

func get_cells_around_player(pos:Vector2i):
	return fog_relatives.duplicate()

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
