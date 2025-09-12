extends TileMapLayer

func _ready():
	for y in range(256):
		for x in range(256):
			set_cell(Vector2i(x-128, y-128), 0, Vector2i(15, 0))
