extends Container
@onready var sprite_2d: Sprite2D = $Sprite2D
var data: CardData = Game.data_card_selected
var caster: int = 0

func _ready() -> void:
	sprite_2d.texture = data.texture
	var targets := Game.get_targets(data.targeting, caster)
	data.effect.apply(targets)
