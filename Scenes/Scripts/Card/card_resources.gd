extends Resource
class_name CardData
enum Targeting {SELF,ENEMY,ALL,NONE}

@export var card_name: String
@export var texture: Texture2D
@export var targeting : Targeting
@export var effect: CardEffect
