extends Container
@onready var sprite_2d: Sprite2D = $Sprite2D
var data: CardData
var caster: int = 0

func _ready() -> void:
	sprite_2d.texture = data.texture
