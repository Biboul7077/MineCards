# biome_effect.gd — une autre stratégie
extends CardEffect
class_name BiomeEffect

@export_enum("PLAINS","DESERT","ICEBIOME") var biome: String = "PLAINS"

func apply(targets: Array[int]) -> void:
	for t in targets:
		Game.set_biome(t, biome)
