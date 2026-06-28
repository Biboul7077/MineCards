extends HBoxContainer
const HOVER_DURATION := 0.2
const HOVER_OFFSET_Y := 100
const HOVER_OFFSET_X := 60
const HOVER_SCALE := 1.3
const GOLEM_CARD_DATA = preload("uid://dxyc27dcvi1bx")
const ICEBIOME_CARD_DATA = preload("uid://ccrhxvs0m6oe4")
const ICEBLOCK_CARD_DATA = preload("uid://civbdfvia07n0")
const KIBBLE_CARD_DATA = preload("uid://cxw6rv70lghs6")
const PLAIN_CARD_DATA = preload("uid://u55bj2xwxigl")
const SLIME_CARD_DATA = preload("uid://b48py5wsyvpru")
const CARD = preload("uid://bdpcythmlvs3r")

var deck = [SLIME_CARD_DATA,ICEBLOCK_CARD_DATA,PLAIN_CARD_DATA,GOLEM_CARD_DATA,ICEBIOME_CARD_DATA,KIBBLE_CARD_DATA]
var max_card_allowed : int = 6
var card_height : int = 112
var card_length : int = 84
var start_position = 0

func _ready() -> void:
	for i in deck:
		var card_temp = CARD.instantiate()
		card_temp.data = i
		add_child(card_temp)
	self.size.x = max_card_allowed * card_height
	self.pivot_offset.x = max_card_allowed * card_length/2
	var project_resolution_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var project_resolution_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	self.global_position.x = project_resolution_width/4
	self.global_position.y = project_resolution_height - HOVER_OFFSET_X
	start_position = self.position

func _on_mouse_entered() -> void:
	var target_position = start_position + Vector2(0,-HOVER_OFFSET_Y)
	var tween_position = get_tree().create_tween()
	var tween_scale = get_tree().create_tween()
	tween_position.tween_property(self,"position",target_position,HOVER_DURATION)
	tween_scale.tween_property(self,"scale",Vector2(HOVER_SCALE,HOVER_SCALE),HOVER_DURATION)


func _on_mouse_exited() -> void:
	if !Game.card_selected:
		var tween_position = get_tree().create_tween()
		var tween_scale = get_tree().create_tween()
		tween_position.tween_property(self,"position",start_position,HOVER_DURATION)
		tween_scale.tween_property(self,"scale",Vector2(1,1),HOVER_DURATION)
