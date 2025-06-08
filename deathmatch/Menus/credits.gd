extends Control

@onready var high_score: Label = %CreditsHighScore

func _ready() -> void:
	high_score.text = str(GameManager.high_score)
