extends Node
const BIOME_COORDINATE := {"PLAINS":Vector2i(0,2),"DESERT":Vector2i(1,2),"ICEBIOME":Vector2i(2,2)}
const MAX_HEALTH := 17
enum PLAYERS {PLAYER0,PLAYER1}

var card_selected := false
var card_holder_node: Node
var card_placement_node: Control
var data_card_selected : CardData
var mouse_on_placement = false
var current_player := PLAYERS.PLAYER0
var current_biome := ["",""]
var armor := [0,0]
var health := [17,17]

signal changing_biome(args)
signal changing_health(args)

@onready var card_holder: Node = $CardHolder

func set_biome(target,biome):
	current_biome[target] = biome
	emit_signal("changing_biome",{"coord":BIOME_COORDINATE[biome],"target":target})

func set_health(target,value,biome):
	if biome == current_biome[target] and biome != "":
		value *= 1.5
	if value < 0:
		health[target] = clamp(health[target]+min(armor[target]+value,0),0,17)
		armor[target] = 0
	else:
		health[target] = clamp(health[target]+value,0,17)
	emit_signal("changing_health",{"damage":health[target],"target":target})

func set_armor(target,value,biome):
	if biome == current_biome[target] and biome != "":
		value *= 1.5
	armor[target] = value

func get_targets(targeting: CardData.Targeting, caster: int) -> Array[int]:
	var opponent := 1 - caster
	match targeting:
		CardData.Targeting.SELF:
			return [caster]
		CardData.Targeting.ENEMY:
			return [opponent]
		CardData.Targeting.ALL:
			return [caster, opponent]
		CardData.Targeting.NONE:
			return []
	return []
