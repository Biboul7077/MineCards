extends Resource
class_name CardData

@export var card_name: String
@export var texture: Texture2D
@export var effect_name: String
@export_range(0,2) var target: int = 0
@export var biome: String = ""
@export var value: int
