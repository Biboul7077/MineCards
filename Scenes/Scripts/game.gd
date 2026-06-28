extends Node
const BIOME_COORDINATE := {"PLAINS":Vector2i(0,2),"DESERT":Vector2i(1,2),"ICEBIOME":Vector2i(2,2)}
enum PLAYERS {PLAYER1,PLAYER2}

var cardSelected
var dataCardSelected : CardData
var mouseOnPlacement = false
var target := [0,0]
var current_biome := ["",""]
var health := [17,17]

signal changing_biome(biome)
signal changing_health(value)

func set_biome(value,target,biome):
	print(BIOME_COORDINATE[biome])
	current_biome[target] = biome
	emit_signal("changing_biome",{"coord":BIOME_COORDINATE[biome],"target":target})

func set_health(value,target,biome):
	if biome == current_biome[target] and biome != "":
		value *= 1.5
	health[target] = clamp(health[target]+value,0,17)
	emit_signal("changing_health",{"damage":health[target],"target":target})

func set_target(targetting):
	if targetting == "SELF":
		target[PLAYERS.PLAYER1] = 1
		target[PLAYERS.PLAYER2] = 0
	elif targetting == "OTHER":
		target[PLAYERS.PLAYER1] = 0
		target[PLAYERS.PLAYER2] = 1
	elif targetting == "ALL":
		target[PLAYERS.PLAYER1] = 1
		target[PLAYERS.PLAYER2] = 1
	elif targetting == "NONE":
		target[PLAYERS.PLAYER1] = 0
		target[PLAYERS.PLAYER2] = 0
