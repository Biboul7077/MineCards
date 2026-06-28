extends TileMapLayer
@export var target := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.connect("changing_biome",changing_biome_texture)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func changing_biome_texture(biome):
	for cell in get_used_cells():
		var tile_data = get_cell_tile_data(cell)

		if tile_data != null:
			var source_id = get_cell_source_id(cell)

			print("Cellule :", cell, " ID :", source_id)

			set_cell(cell,0,biome["coord"])
