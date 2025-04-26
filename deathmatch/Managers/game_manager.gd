extends Node

signal dead


var health: int = 5:
	set (value):
		health = value
		if (health <= 0):
			health = 0
			dead.emit()
			print("Game Over")
	get:
		return health

var score: int = 0:
	set (value):
		score = value * chain_multiplier
		chain_multiplier += 1
	get:
		return score

var chain_multiplier: int = 1:
	set(value):
		chain_multiplier = value
		if chain_multiplier <= 0:
			chain_multiplier = 1
	get:
		return chain_multiplier

var high_score:int

##Game Won events
func game_won() -> void:
	high_score = score
	pass
