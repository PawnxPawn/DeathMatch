extends Node

signal dead
signal updated_values(health_update: int, score_update: int, multiplier_update: int)

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

##Game Won events
func game_won() -> void:
	high_score = score
	print(high_score)
	pass
