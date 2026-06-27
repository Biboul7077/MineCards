extends Container
@onready var sprite_2d: Sprite2D = $Sprite2D
var data := Game.dataCardSelected
var effect := Callable(Game,data.effect_name)

func _ready() -> void:
	sprite_2d.texture = data.texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	effect.call(data.value,data.target)
	queue_free()
