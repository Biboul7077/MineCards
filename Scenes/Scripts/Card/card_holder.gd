extends Container
@onready var sprite_2d: Sprite2D = $Sprite2D
var data := Game.dataCardSelected
var cardHeld = ""

func _ready() -> void:
	sprite_2d.texture = data.texture

func _process(delta: float) -> void:
	self.global_position = get_global_mouse_position()
