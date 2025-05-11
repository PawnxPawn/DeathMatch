extends Control

@onready var health_hand_anim_player: AnimationPlayer = %HealthHandAnimPlayer
@onready var score_label: Label = %ScoreLabel
@onready var multiplier_label: Label = %MultiplierLabel

func _ready() -> void:
	GameManager.updated_values.connect(update_hud)
	update_hud(GameManager.health, GameManager.score, GameManager.chain_multiplier)

func update_hud(health: int, score: int, chain_multiplier: int) -> void:
	health_hand_anim_player.stop()
	health_hand_anim_player.play(str(health))
	score_label.text = str(score)
	multiplier_label.text = "x {0}".format([str(chain_multiplier)])
