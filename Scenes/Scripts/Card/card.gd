extends Container
@export var data: CardData
@onready var animation_card: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var card = preload("uid://yweyrc4x4ycp")

var card_highlighted = false

func _ready() -> void:
	sprite_2d.texture = data.texture

func _on_mouse_entered() -> void:
	animation_card.play("Select")
	card_highlighted = true


func _on_mouse_exited() -> void:
	animation_card.play("Deselect")
	card_highlighted = false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.button_mask == 1:
			if card_highlighted:
				Game.data_card_selected = data
				var card_temp = card.instantiate()
				Game.card_holder_node.add_child(card_temp)
				Game.card_selected = true
				sprite_2d.visible = false
		elif event.button_mask == 0:
			if Game.mouse_on_placement == false:
				card_highlighted = false
				sprite_2d.visible = true
			else:
				self.queue_free()
				Game.card_placement_node.place_card()
			for child in Game.card_holder_node.get_children():
				child.queue_free()
			Game.card_selected = false
