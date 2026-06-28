extends Container
@onready var sprite_2d: Sprite2D = $Sprite2D
var data: CardData = Game.dataCardSelected
var caster: int = 0

func _ready() -> void:
	sprite_2d.texture = data.texture
	for t in Game.get_targets(data.targeting, caster):
		data.effect.apply(Game.get_targets(data.targeting, caster))
