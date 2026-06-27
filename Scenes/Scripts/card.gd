extends Container
@export var data: CardData
@onready var animation_card: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var card = preload("res://Scenes/card_holder.tscn")

var cardPosition
var cardHighlighted = false

func _ready() -> void:
	sprite_2d.texture = data.texture

func _on_mouse_entered() -> void:
	animation_card.play("Select")
	cardHighlighted = true


func _on_mouse_exited() -> void:
	animation_card.play("Deselect")
	cardHighlighted = false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.button_mask == 1:
			if cardHighlighted:
				Game.dataCardSelected = data
				var cardTemp = card.instantiate()
				get_tree().get_root().get_node("Board/CardHolder").add_child(cardTemp)
				Game.cardSelected = true
				self.get_child(0).visible = false
		elif event.button_mask == 0:
			if Game.mouseOnPlacement == false:
				cardHighlighted = false
				self.get_child(0).visible = true
			else:
				self.queue_free()
				get_node("../../CardPlacement").place_card()
			for i in get_tree().get_root().get_node("Board/CardHolder").get_child_count():
				get_tree().get_root().get_node("Board/CardHolder").get_child(i).queue_free()
			Game.cardSelected = false
