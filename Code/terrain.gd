extends TileMapLayer

const tiledepths = {
	0.1: Vector2i(6, 0),
	0.2: Vector2i(5, 0),
	1.0: Vector2i(0, 0),
}
const biomedepths = {
	-0.3: Vector2i(3, 0),
	0.2: Vector2i(0, 0),
	1.0: Vector2i(0, 1),
}

func Generate(noiseseed):
	var noise = NoiseTexture2D.new()
	var biomenoise = NoiseTexture2D.new()
	noise.noise = FastNoiseLite.new()
	biomenoise.noise = FastNoiseLite.new()
	noise.noise.seed = noiseseed
	biomenoise.noise.seed = noiseseed + 1
	for y in range(256):
		for x in range(256):
			var perlincoord = noise.noise.get_noise_2d(x, y)
			var atlascoords = Vector2i()
			for d in tiledepths.keys():
				if perlincoord < d:
					atlascoords = tiledepths[d]
					break
			if atlascoords == Vector2i(0, 0):
				for d in biomedepths.keys():
					if biomenoise.noise.get_noise_2d(x, y) < d:
						atlascoords = biomedepths[d]
						break
			set_cell(Vector2i(x-128, y-128), 0, atlascoords)
func _ready():
	Generate(randi())
func _input(event: InputEvent) -> void:
	if event.is_action("lmb") and event.is_pressed():
		$"../Player"._on_terrain_click(map_to_local(local_to_map(get_global_mouse_position())))
