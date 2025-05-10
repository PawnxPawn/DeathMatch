extends Control

@onready var health_hand_anim_player: AnimationPlayer = %HealthHandAnimPlayer
@onready var score_label: Label = %ScoreLabel
@onready var multiplier_label: Label = %MultiplierLabel

#All of the Texture Regions for the Hand. Hard-coded this because we don't need to change this at all.
const health_remaining:Array[Rect2] = [Rect2(1415, 156, 169, 145), 
Rect2(1088, 45, 231, 257),
Rect2(834, 52, 250, 258),
Rect2(569, 54, 249, 261),
Rect2(280, 25, 263, 314),
Rect2(0, 14, 276, 624)]

func _ready() -> void:
	GameManager.updated_values.connect(update_hud)
	update_hud(GameManager.health, GameManager.score, GameManager.chain_multiplier)

func update_hud(health: int, score: int, chain_multiplier: int) -> void:
	health_hand_anim_player.stop()
	health_hand_anim_player.play(str(health))
	score_label.text = str(score)
	multiplier_label.text = "x {0}".format([str(chain_multiplier)])
