extends HBoxContainer
const BEE_CARD_DATA = preload("uid://bdi5ekhxi6ob8")
const GOLEM_CARD_DATA = preload("uid://dxyc27dcvi1bx")
const ICEBIOME_CARD_DATA = preload("uid://ccrhxvs0m6oe4")
const ICEBLOCK_CARD_DATA = preload("uid://civbdfvia07n0")
const JOLL_CARD_DATA = preload("uid://7ia6sijvc7tf")
const KIBBLE_CARD_DATA = preload("uid://cxw6rv70lghs6")
const PLAIN_CARD_DATA = preload("uid://u55bj2xwxigl")
const SLIME_CARD_DATA = preload("uid://b48py5wsyvpru")
const CARD = preload("uid://bdpcythmlvs3r")

var deck = [SLIME_CARD_DATA,ICEBLOCK_CARD_DATA,PLAIN_CARD_DATA,GOLEM_CARD_DATA,ICEBIOME_CARD_DATA,KIBBLE_CARD_DATA]
var maxCardAllowed : int = 6
var cardLength : int = 112
var startPosition = 0

func _ready() -> void:
	for i in deck:
		var cardTemp = CARD.instantiate()
		cardTemp.data = i
		add_child(cardTemp)
	self.size.x = maxCardAllowed * cardLength
	self.pivot_offset.x = maxCardAllowed * 52.5
	var projectResolutionWidth = ProjectSettings.get_setting("display/window/size/viewport_width")
	var projectResolutionHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
	self.global_position.x = projectResolutionWidth/4
	self.global_position.y = projectResolutionHeight - 60
	startPosition = self.position

func _on_mouse_entered() -> void:
	var target_position = startPosition + Vector2(0,-100)
	var tween_position = get_tree().create_tween()
	var tween_scale = get_tree().create_tween()
	tween_position.tween_property(self,"position",target_position,0.2)
	tween_scale.tween_property(self,"scale",Vector2(1.3,1.3),0.2)


func _on_mouse_exited() -> void:
	if !Game.cardSelected:
		var tween_position = get_tree().create_tween()
		var tween_scale = get_tree().create_tween()
		tween_position.tween_property(self,"position",startPosition,0.2)
		tween_scale.tween_property(self,"scale",Vector2(1,1),0.2)
