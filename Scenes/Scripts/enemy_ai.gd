extends Node
class_name EnemyAI

enum Style {ENDURANCE, AGGRESSIVE}

@export var style: Style = Style.ENDURANCE
var enemy_deck: Array[CardData] = [
	preload("uid://dpnbdajpg2ihf"),
	preload("uid://bwbf2x1etfd0x"),
	preload("uid://u0ikkeckrxy1"),
	preload("uid://gstpso5hmokm"),
	preload("uid://cosxoug1sqsdp")
]

const ME := 1
const FOE := 0

func _ready() -> void:
	Game.hand[ME] = enemy_deck.duplicate()
	Game.turn_resolved.connect(_on_turn_resolved)
	call_deferred("_maybe_play") # laisse Game._ready() se terminer en premier

func _on_turn_resolved(_played: Array) -> void:
	_maybe_play()

func _maybe_play() -> void:
	if Game.phase == Game.Phase.SELECTION and Game.pending_card[ME] == null and not Game.hand[ME].is_empty():
		play_turn()

func play_turn() -> void:
	var hand: Array = Game.hand[ME]
	var best: CardData = hand[0]
	var best_score := -INF
	for card in hand:
		var s := _score(card)
		if s > best_score:
			best_score = s
			best = card
	Game.submit_card(ME, best)

func _score(card: CardData) -> float:
	var e := card.effect
	if e is BiomeEffect:
		return _score_biome(e)
	elif e is ArmorEffect:
		return _score_armor(e)
	elif e is HealthEffect:
		return _score_health(e)
	return 0.0

func _score_health(e: HealthEffect) -> float:
	var bonus := 1.5 if e.biome == Game.current_biome[ME] and e.biome != "" else 1.0
	if e.amount < 0:
		var dmg: float = -e.amount * bonus
		var effective = max(dmg - Game.armor[FOE], 0.0)
		var w := 2.0 if style == Style.AGGRESSIVE else (0.6 if not _foe_is_exhausted() else 2.5)
		var score = w * effective
		if Game.health[FOE] - effective <= 0:
			score += 1000.0 # priorité au coup de grâce, peu importe le style
		return score
	else:
		var w := 1.5 if style == Style.ENDURANCE else 0.8
		var missing = Game.MAX_HEALTH - Game.health[ME]
		return w * min(e.amount * bonus, missing)

func _score_armor(e: ArmorEffect) -> float:
	var bonus := 1.5 if e.biome == Game.current_biome[ME] and e.biome != "" else 1.0
	var w := 1.6 if style == Style.ENDURANCE else 0.7
	return w * e.amount * bonus

func _score_biome(e: BiomeEffect) -> float:
	if e.biome == Game.current_biome[ME]:
		return -10.0
	return 1.0

func _foe_is_exhausted() -> bool:
	var threat := 0.0
	for card in Game.hand[FOE]:
		if card.effect is HealthEffect and card.effect.amount < 0:
			threat += -card.effect.amount
	return threat < 8.0 # seuil à ajuster en testant
