extends Node

signal dead

var health: int = 5:
	set (value):
		health = value
		if (health <= 0):
			health = 0
			dead.emit()
	get:
		return health

var score: int = 0:
	set (value):
		score = value
	get:
		return score
