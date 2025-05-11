extends Node

signal updated_values(health_update: int, score_update: int, multiplier_update: int)



@onready var death_timer : Timer = %DeathTimer

enum GameDifficulty {
	EASY = 0,
	NORMAL = 1,
	HARD = 2,
}

var knife_cursor = load("res://Assets/Cursor/selector_sword_crop.png")
var standard_cursor = load("res://Assets/Cursor/Cursor.png")

var has_won_game: bool = false
var difficulty: GameDifficulty = GameDifficulty.NORMAL

var _end_game_scene: StringName = &"uid://baq13tim2y7vx"

const _MAX_HEALTH: int = 5

var health: int = _MAX_HEALTH:
	set (value):

		health = value

		if (health > _MAX_HEALTH):
			health = _MAX_HEALTH
		elif (health <= 0):
			health = 0
			end_game(false)
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
	_set_default_cursor()


func _set_default_cursor() -> void:
	Input.set_custom_mouse_cursor(standard_cursor, Input.CURSOR_ARROW, Vector2(12, 9))


func reset_game() -> void:
	get_tree().paused = false
	health = 5
	score = 0
	chain_multiplier = 1


func end_game(has_won:bool) -> void:
	has_won_game = has_won
	high_score = score if score > high_score else high_score
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if (!has_won):
		death_timer.start()
		await death_timer.timeout
	get_tree().change_scene_to_file(_end_game_scene)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print(high_score)
	pass
