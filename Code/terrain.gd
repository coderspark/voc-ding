extends TileMapLayer


func _input(event: InputEvent) -> void:
	if event.is_action("lmb") and event.is_pressed():
		$"../Player"._on_terrain_click(map_to_local(local_to_map(get_global_mouse_position())))
