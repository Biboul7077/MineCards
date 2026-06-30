extends Node
const BIOME_COORDINATE := {"PLAINS":Vector2i(0,2),"DESERT":Vector2i(1,2),"ICEBIOME":Vector2i(2,2)}
const MAX_HEALTH := 17
enum PLAYERS {PLAYER0,PLAYER1}
enum Phase {PREPARATION, SELECTION, RESOLUTION, GAME_OVER}

var card_selected := false
var card_holder_node: Node
var card_placement_node: Control
var data_card_selected : CardData
var mouse_on_placement = false
var current_player := PLAYERS.PLAYER0
var current_biome := ["",""]
var armor := [0,0]
var health := [17,17]

var phase: Phase = Phase.PREPARATION
var hand: Array = [[], []]          # stock fini de chaque joueur, ne se reconstitue jamais
var pending_card: Array = [null, null]
var winner: int = -1

signal changing_biome(args)
signal changing_health(args)
signal turn_resolved(played: Array)
signal game_over(winner: int)

@onready var card_holder: Node = $CardHolder

func _ready() -> void:
	# TODO: passer en Phase.SELECTION seulement après la phase de préparation
	# (choix des biomes) une fois celle-ci câblée. Pour l'instant on saute direct.
	phase = Phase.SELECTION

func set_biome(target,biome):
	current_biome[target] = biome
	emit_signal("changing_biome",{"coord":BIOME_COORDINATE[biome],"target":target})

func set_health(target,value,biome):
	if biome == current_biome[target] and biome != "":
		value *= 1.5
	if value < 0:
		health[target] = clamp(health[target]+min(armor[target]+value,0),0,17)
		armor[target] = 0
	else:
		health[target] = clamp(health[target]+value,0,17)
	emit_signal("changing_health",{"damage":health[target],"target":target})

func set_armor(target,value,biome):
	if biome == current_biome[target] and biome != "":
		value *= 1.5
	armor[target] = value

func get_targets(targeting: CardData.Targeting, caster: int) -> Array[int]:
	var opponent := 1 - caster
	match targeting:
		CardData.Targeting.SELF:
			return [caster]
		CardData.Targeting.ENEMY:
			return [opponent]
		CardData.Targeting.ALL:
			return [caster, opponent]
		CardData.Targeting.NONE:
			return []
	return []

## --- Gestion des tours ---

func submit_card(player: int, data: CardData) -> void:
	if phase != Phase.SELECTION or pending_card[player] != null:
		return
	pending_card[player] = data
	hand[player].erase(data)
	if pending_card[0] != null and pending_card[1] != null:
		_resolve_turn()

func _resolve_turn() -> void:
	phase = Phase.RESOLUTION
	var played := pending_card.duplicate()

	# Révélation visuelle des deux cartes en même temps
	if card_placement_node and card_placement_node.has_method("reveal_card"):
		for p in [0, 1]:
			if played[p] != null:
				card_placement_node.reveal_card(played[p], p)

	# Ordre d'application : biome -> armure -> soin/attaque, pour que la pose
	# d'armure ou le changement de biome de CE tour protège bien contre
	# l'attaque de CE même tour.
	var order := [0, 1]
	order.sort_custom(func(a, b): return _priority(played[a]) < _priority(played[b]))
	for p in order:
		var data: CardData = played[p]
		if data == null:
			continue
		var targets := get_targets(data.targeting, p)
		data.effect.apply(targets)

	pending_card = [null, null]
	emit_signal("turn_resolved", played)
	_check_game_over()
	if phase != Phase.GAME_OVER:
		phase = Phase.SELECTION

func _priority(data: CardData) -> int:
	if data == null:
		return 99
	if data.effect is BiomeEffect:
		return 0
	if data.effect is ArmorEffect:
		return 1
	return 2 # HealthEffect (soin ou attaque)

func _check_game_over() -> void:
	var dead0 = health[0] <= 0
	var dead1 = health[1] <= 0
	var hands_empty = hand[0].is_empty() and hand[1].is_empty()

	if dead0 or dead1 or hands_empty:
		phase = Phase.GAME_OVER
		if health[0] == health[1]:
			winner = -1 # égalité
		else:
			winner = 0 if health[0] > health[1] else 1
		emit_signal("game_over", winner)
