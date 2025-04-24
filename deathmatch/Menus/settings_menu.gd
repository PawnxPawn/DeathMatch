extends Control

signal return_control

func _on_return_button_pressed() -> void:
	return_control.emit()
