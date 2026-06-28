extends CardEffect
class_name HealthEffect

@export var amount: int = 0
@export_enum("PLAINS","DESERT","ICEBIOME") var biome: String = "PLAINS"

func apply(targets: Array[int]) -> void:
	for t in targets:
		Game.set_health(t, amount, biome)
