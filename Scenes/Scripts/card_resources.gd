extends Resource
class_name CardData

@export var card_name: String
@export var texture: Texture2D
@export var effect_name: String
@export_enum("SELF","OTHER","ALL","NONE") var target: String = "OTHER"
@export_enum("PLAINS","DESERT","ICEBIOME") var biome: String = "PLAINS"
@export var value: int = 0
