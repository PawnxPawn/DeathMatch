extends Node

signal dead
signal updated_values(health_update: int, score_update: int, multiplier_update: int)

var knife_cursor = load("res://Assets/Cursor/selector_sword_crop.png")
var standard_cursor = load("res://Assets/Cursor/Cursor.png")

var health: int = 5:
	set (value):
		health = value
		if (health <= 0):
			health = 0
			dead.emit()
			print("Game Over")
		updated_values.emit(health, score, chain_multiplier)
	get:
		return health

var score: int = 0:
	set (value):
		score = value * chain_multiplier
		chain_multiplier += 1
		updated_values.emit(health, score, chain_multiplier)
	get:
		return score

var chain_multiplier: int = 1:
	set(value):
		chain_multiplier = value
		if chain_multiplier <= 0:
			chain_multiplier = 1
		updated_values.emit(health, score, chain_multiplier)
	get:
		return chain_multiplier

var high_score:int


func _ready() -> void:
	# Set the default cursor
	Input.set_custom_mouse_cursor(standard_cursor, Input.CURSOR_ARROW, Vector2(12, 9))


func reset_game() -> void:
	get_tree().paused = false
	health = 5
	score = 0
	chain_multiplier = 1



##Game Won events
func game_won() -> void:
	high_score = score if score > high_score else high_score
	print(high_score)
	pass
