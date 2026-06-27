extends Node

var cardSelected
var dataCardSelected : CardData
var mouseOnPlacement = false
var biome := [-1,-1]
var health := [17,17]

signal changing_biome(next_biome)
signal changing_health(value)

func set_biome(value,target):
	biome[target] = value
	emit_signal("changing_biome",[biome[target],target])

func set_health(value,target):
	print("emitting")
	health[target] = clamp(health[target]+value,0,17)
	emit_signal("changing_health",[health[target],target])
