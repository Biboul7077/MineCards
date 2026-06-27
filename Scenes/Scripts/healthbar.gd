extends TileMapLayer
var health_max := 17
var health := 17
var health_cell := []
var health_cell_above := []
var health_cell_below := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.connect("changing_health",changing_health_texture)
	health_cell = get_used_cells().duplicate()
	health_cell.reverse()
	health_cell_above = health_cell.filter(is_above)
	health_cell_below = health_cell.filter(is_below)
	print(len(health_cell_above))
	print(len(health_cell_below))
	

func is_above(coord: Vector2i) -> bool:
	return coord.y >= 10

func is_below(coord: Vector2i) -> bool:
	return coord.y < 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func changing_health_texture(value):
	print(value[0])
	health = value[0]
	var delta_health := health_max-health
	var i := 1
	for cell in health_cell_above:
		var tile_data = get_cell_tile_data(cell)

		if i <= delta_health:
			set_cell(cell,1,Vector2i(1,1))
			set_cell(health_cell_below[i-1],1,Vector2i(1,1))
		i += 1
