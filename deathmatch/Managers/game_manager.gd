extends Node

var _health: int
var _score: int

signal dead

func add_health(amount: int) -> void:
    _health += amount

func remove_health(amount: int) -> void:
    _health -= amount
    if (_health <= 0):
        _health = 0
        dead.emit()

func get_health() -> int:
    return _health

func add_score(amount: int) -> void:
    _score += amount

func remove_score(amount: int) -> void:
    _score -= amount

func get_score() -> int:
    return _score
