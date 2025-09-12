# Handles Everything Terrain Related (still needs mountains and tundra smh)

extends TileMapLayer

# Dictionary for what perlin noise layers corrispond to what tiles
const tiledepths = {
	0.1: Vector2i(6, 0), # Deep water
	0.2: Vector2i(5, 0), # Shallow Water
	1.0: Vector2i(0, 0), # Grass Tile. Will be run through more perlin noise for features
}

# Biome Dictionary
const biomedepths = {
	-0.2: Vector2i(2, 0), # Desert
	1.0: Vector2i(0, 0),  # Plains
}

func Generate(noiseseed):
	var noise = NoiseTexture2D.new()        # Perlin for terrain
	var biomenoise = NoiseTexture2D.new()   # Perlin for biomes
	var featurenoise = NoiseTexture2D.new() # Perlin for features such as hills, oases, and forests
	noise.noise = FastNoiseLite.new()       # Set the noise
	biomenoise.noise = FastNoiseLite.new()  # Set the noise
	featurenoise.noise = FastNoiseLite.new()# Set the noise
	noise.noise.seed = noiseseed            # Set the seed
	# Offset seeds so that features aren't related to the landmasses
	biomenoise.noise.seed = noiseseed + 1 
	featurenoise.noise.seed = noiseseed - 1
	# Set all the tiles
	for y in range(256):
		for x in range(256):
			var perlincoord = noise.noise.get_noise_2d(x, y)
			var atlascoords = Vector2i() # Coordinates on the atlas
			for d in tiledepths.keys():
				if perlincoord < d:
					atlascoords = tiledepths[d]
					break
			# If the tile is land, run it through biomes
			if atlascoords == Vector2i(0, 0):
				for d in biomedepths.keys():
					if biomenoise.noise.get_noise_2d(x, y) < d:
						atlascoords = biomedepths[d]
						break
				# Features
				# Hills
				if featurenoise.noise.get_noise_2d(x*5,y*5) < 0.3 && featurenoise.noise.get_noise_2d(x*5, y*5) > 0.1:
					atlascoords += Vector2i(1, 0) # Use += for less if statements
				# Forests for grassland
				if atlascoords.y == 0 && atlascoords.x < 2 && featurenoise.noise.get_noise_2d(x*10,y*10) > -0.2 && featurenoise.noise.get_noise_2d(x*10,y*10) < 0.1:
					atlascoords += Vector2i(0, 1) # Set to forest
				# Oases
				if atlascoords == Vector2i(2, 0) && featurenoise.noise.get_noise_2d(x*100,y*100) > 0.42: # haha 42 life the universe and everything :p
					atlascoords.x += 2
				# Variation in the tile sprites
				if atlascoords == Vector2i(4, 0) && randi_range(0, 1) == 0:
					atlascoords = Vector2i(4, 1)
				if atlascoords == Vector2i(1, 0) && randi_range(0, 1) == 0:
					atlascoords = Vector2i(1, 2)
				if atlascoords == Vector2i(0, 1):
					atlascoords.y += randi_range(0, 2)
			
			# Set the cell finally
			set_cell(Vector2i(x-128, y-128), 0, atlascoords)
func _ready():
	# Random seed :p probably going to add a set seed option later
	Generate(randi())
# Check for click on terrain for movement
func _input(event: InputEvent) -> void:
	if event.is_action("lmb") and event.is_pressed():
		$"../Player"._on_terrain_click(map_to_local(local_to_map(get_global_mouse_position())))
