extends Node

func _ready() -> void:
	Game.card_holder_node = $BoardCardHolder
	Game.card_placement_node = $UI/CardPlacement
