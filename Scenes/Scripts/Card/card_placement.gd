extends Control
var card_on_board = preload("uid://cymr8o0l3wclc")

func _on_mouse_entered() -> void:
	Game.mouse_on_placement = true

func _on_mouse_exited() -> void:
	Game.mouse_on_placement = false

func place_card():
	var card_temp = card_on_board.instantiate()
	var project_resolution_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var project_resolution_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	card_temp.global_position = Vector2(project_resolution_width/2,project_resolution_height/2) - self.position
	card_temp.data = Game.data_card_selected
	card_temp.caster = Game.current_player
	add_child(card_temp)
