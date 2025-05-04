extends Control

signal return_control

func _on_return_button_pressed() -> void:
	return_control.emit()

#func _on_return_button_mouse_entered() -> void:
#	GameManager.change_cursor(true)

#func _on_return_button_mouse_exited() -> void:
#	GameManager.change_cursor(false)
