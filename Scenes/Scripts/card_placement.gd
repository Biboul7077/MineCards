extends Control
var card_on_board = preload("res://Scenes/card_on_board.tscn")

func _on_mouse_entered() -> void:
	Game.mouseOnPlacement = true

func _on_mouse_exited() -> void:
	Game.mouseOnPlacement = false

func place_card():
	var cardTemp = card_on_board.instantiate()
	var projectResolutionWidth = ProjectSettings.get_setting("display/window/size/viewport_width")
	var projectResolutionHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
	cardTemp.global_position = Vector2(projectResolutionWidth/2,projectResolutionHeight/2) - self.position
	cardTemp.data = Game.dataCardSelected
	add_child(cardTemp)
