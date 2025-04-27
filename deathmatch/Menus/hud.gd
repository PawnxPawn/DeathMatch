extends Control

@onready var hand_life_counter: TextureRect = %HandLifeCounter
@onready var score_label: Label = %ScoreLabel
@onready var hand_life_counter_bg: PanelContainer = %HandLifeCounterBg
@onready var multiplier_label: Label = %MultiplierLabel

#All of the Texture Regions for the Hand. Hard-coded this because we don't need to change this at all.
const health_remaining:Array[Rect2] = [Rect2(1415, 156, 169, 145), 
Rect2(1088, 45, 231, 257),
Rect2(834, 52, 250, 258),
Rect2(569, 54, 249, 261),
Rect2(280, 25, 263, 314),
Rect2(0, 14, 276, 624)]

#Hard Coding this because getting the size of the health_remaining Rect2 array is not working.
const health_remaining_bg_size: Array[Vector2] = [Vector2(408, 590), Vector2(408, 644)]

func _ready() -> void:
	GameManager.updated_values.connect(update_hud)
	update_hud(GameManager.health, GameManager.score, GameManager.chain_multiplier)

func update_hud(health: int, score: int, chain_multiplier: int) -> void:
	hand_life_counter.texture.region = health_remaining[health]
	if (health == 5):
		hand_life_counter_bg.size = health_remaining_bg_size[1]
	else:
		hand_life_counter_bg.size = health_remaining_bg_size[0]
	score_label.text = str(score)
	multiplier_label.text = "x {0}".format([str(chain_multiplier)])
