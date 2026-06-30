extends Control
var card_on_board = preload("uid://dnmnrro0ee7t1")

func _on_mouse_entered() -> void:
	Game.mouse_on_placement = true

func _on_mouse_exited() -> void:
	Game.mouse_on_placement = false

func reveal_card(data: CardData, caster: int) -> void:
	var card_temp = card_on_board.instantiate()
	var project_resolution_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var project_resolution_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	# Léger décalage pour distinguer les deux cartes tant qu'il n'y a
	# qu'une seule zone de résolution sur le board.
	var offset := Vector2(-40, 0) if caster == 0 else Vector2(40, 0)
	card_temp.global_position = Vector2(project_resolution_width/2,project_resolution_height/2) - self.position + offset
	card_temp.data = data
	card_temp.caster = caster
	add_child(card_temp)
