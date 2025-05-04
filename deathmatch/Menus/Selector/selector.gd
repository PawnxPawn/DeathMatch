extends PanelContainer

func set_selector_position(new_position: Vector2, offset: Vector2 = Vector2.ZERO) -> void:
	global_position = new_position + offset
