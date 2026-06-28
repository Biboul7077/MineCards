extends TileMapLayer

## Index du joueur concerné par cette barre (0 = joueur, 1 = adversaire).
## A régler dans l'inspecteur pour chaque instance (HealthbarPlayer / HealthbarOpponent).
@export var target := 0
@export var health_max := 17

const DAMAGED_SOURCE := 1
const DAMAGED_ATLAS := Vector2i(1, 1)

var health := health_max
var health_pairs: Array = [] # [{above, below, above_source, above_atlas, below_source, below_atlas}, ...]

func _ready() -> void:
	Game.connect("changing_health",changing_health_texture)
	_build_health_pairs()

func _build_health_pairs() -> void:
	var cells := get_used_cells()
	if cells.is_empty():
		return

	# Milieu vertical du contour : toute cellule du haut a sa cellule
	# miroir en bas à (x, mid_y - y).
	var min_y := cells[0].y
	var max_y := cells[0].y
	for cell in cells:
		min_y = mini(min_y, cell.y)
		max_y = maxi(max_y, cell.y)
	var mid_y := min_y + max_y

	var cell_lookup := {}
	for cell in cells:
		cell_lookup[cell] = true

	for cell in cells:
		var mirrored := Vector2i(cell.x, mid_y - cell.y)
		if cell.y * 2 < mid_y and cell_lookup.has(mirrored):
			health_pairs.append({
				"above": cell,
				"below": mirrored,
				"above_source": get_cell_source_id(cell),
				"above_atlas": get_cell_atlas_coords(cell),
				"below_source": get_cell_source_id(mirrored),
				"below_atlas": get_cell_atlas_coords(mirrored),
			})

	health_pairs.sort_custom(func(a, b): return a["above"].x > b["above"].x)

func changing_health_texture(value: Dictionary) -> void:
	if value["target"] != target:
		return
	else:
		health = value["damage"]
		var missing_health := health_max - health

		for i in health_pairs.size():
			var pair = health_pairs[i]
			if i < missing_health:
				set_cell(pair["above"], DAMAGED_SOURCE, DAMAGED_ATLAS)
				set_cell(pair["below"], DAMAGED_SOURCE, DAMAGED_ATLAS)
			else:
				set_cell(pair["above"], pair["above_source"], pair["above_atlas"])
				set_cell(pair["below"], pair["below_source"], pair["below_atlas"])
