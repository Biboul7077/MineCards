extends TileMapLayer
@export var target := 0

func _ready() -> void:
	Game.connect("changing_biome",changing_biome_texture)

func changing_biome_texture(biome):
	if biome["target"] != target:
		return
	else:
		for cell in get_used_cells():
			var tile_data = get_cell_tile_data(cell)

			if tile_data != null:
				var source_id = get_cell_source_id(cell)

				set_cell(cell,0,biome["coord"])
