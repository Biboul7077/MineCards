extends CardEffect
class_name ArmorEffect

@export var amount: int = 0
@export_enum("PLAINS","DESERT","ICEBIOME","OCEAN") var biome: String = "PLAINS"

func apply(targets: Array[int]) -> void:
	for t in targets:
		Game.set_armor(t, amount, biome)
