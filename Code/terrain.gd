extends TileMapLayer

const tiledepths = {
	0.1: Vector2i(6, 0),
	0.2: Vector2i(5, 0),
	1.0: Vector2i(0, 0),
}

func Generate(noiseseed):
	var noise = NoiseTexture2D.new()
	noise.noise = FastNoiseLite.new()
	noise.noise.seed = noiseseed
	for y in range(128):
		for x in range(128):
			var perlincoord = noise.noise.get_noise_2d(x, y)
			var atlascoords = Vector2i()
			for d in tiledepths.keys():
				if perlincoord < d:
					atlascoords = tiledepths[d]
					break
			set_cell(Vector2i(x-64, y-64), 0, atlascoords)
func _ready():
	Generate(randi_range(0,1000000))
func _input(event: InputEvent) -> void:
	if event.is_action("lmb") and event.is_pressed():
		$"../Player"._on_terrain_click(map_to_local(local_to_map(get_global_mouse_position())))
