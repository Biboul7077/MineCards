extends Node
const BIOME_COORDINATE := {"PLAINS":Vector2i(0,2),"DESERT":Vector2i(1,2),"ICEBIOME":Vector2i(2,2)}

var cardSelected
var dataCardSelected : CardData
var mouseOnPlacement = false
var health := [17,17]

signal changing_biome(biome)
signal changing_health(value)

func set_biome(value,target,biome):
	print(BIOME_COORDINATE[biome])
	emit_signal("changing_biome",[BIOME_COORDINATE[biome],target])

func set_health(value,target,biome):
	print("emitting")
	health[target] = clamp(health[target]+value,0,17)
	emit_signal("changing_health",[health[target],target])
