extends Node
const BIOME_COORDINATE := {"PLAINS":Vector2i(0,2),"DESERT":Vector2i(1,2),"ICEBIOME":Vector2i(2,2)}
enum PLAYERS {PLAYER0,PLAYER1}

var cardSelected
var dataCardSelected : CardData
var mouseOnPlacement = false
var current_player := PLAYERS.PLAYER0
var current_biome := ["",""]
var health := [17,17]

signal changing_biome(biome)
signal changing_health(value)

func set_biome(target,biome):
	current_biome[target] = biome
	emit_signal("changing_biome",{"coord":BIOME_COORDINATE[biome],"target":target})

func set_health(target,value,biome):
	if biome == current_biome[target] and biome != "":
		value *= 1.5
	health[target] = clamp(health[target]+value,0,17)
	emit_signal("changing_health",{"damage":health[target],"target":target})

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
