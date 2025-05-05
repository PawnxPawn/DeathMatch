extends Control

@export_category("Selector")
@export var selector: PanelContainer
@export var selector_offset: Vector2

signal return_control

func _on_return_button_pressed() -> void:
	selector.hide()
	return_control.emit()


func _on_mouse_entered() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var node: Node

	for child in %SettingsMenuContainer.get_children():
		if (child is Button or child is HSlider) and child.get_global_rect().has_point(mouse_pos):
			node = child
			break

		for sub_child in child.get_children():
			if sub_child is Button or sub_child is HSlider:
				if sub_child.get_global_rect().has_point(mouse_pos):
					node = sub_child
					break
	
	if node == null: return

	if node is HSlider:
		node = node.get_parent().get_child(0)

	var node_center_point: Vector2 = node.get_global_rect().position
	node_center_point.x -= node.get_global_rect().size.x


	selector.set_selector_position(node_center_point, selector_offset)
	selector.show()


func _on_mouse_exited() -> void:
	#selector.hide()
	pass
	

#func _on_return_button_mouse_entered() -> void:
#	GameManager.change_cursor(true)

#func _on_return_button_mouse_exited() -> void:
#	GameManager.change_cursor(false)
