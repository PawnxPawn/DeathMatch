extends Node

signal dead

var health: int:
    set (value):
        health = value
        if (health <= 0):
            health = 0
            dead.emit()
    get:
        return health

var score: int:
    set (value):
        score = value
    get:
        return health

