extends Control

@export var main_menu: PackedScene
@export var settings_menu: Control
@export var pause_menu_control: Control

@export_category("Selector")
@export var selector: PanelContainer
@export var selector_offset: Vector2

func _ready() -> void:
	pause_menu_control.visible = false

func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("Pause")):
		if (get_tree().paused && settings_menu.visible):
			show_hide()
		else:
			toggle_pause()

func toggle_pause() -> void:
	selector.hide()
	get_tree().paused = !get_tree().paused
	pause_menu_control.visible = !pause_menu_control.visible

func _on_resume_button_pressed() -> void:
	selector.hide()
	pause_menu_control.visible = false
	get_tree().paused = false

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)

func show_hide() -> void:
	settings_menu.visible = !settings_menu.visible
	pause_menu_control.visible = !pause_menu_control.visible

func _on_settings_button_pressed() -> void:
	selector.hide()
	show_hide()

func _on_settings_menu_return_control() -> void:
	show_hide()

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_mouse_entered() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var node: Node

	for child in %PauseMenuContainer.get_children():
		if child is Button and child.get_global_rect().has_point(mouse_pos):
			node = child
			break

	if node == null: return

	var node_center_point: Vector2 = node.get_global_rect().position
	node_center_point.x -= node.get_global_rect().size.x


	selector.set_selector_position(node_center_point, selector_offset)
	selector.show()


func _on_mouse_exited() -> void:
	#selector.hide()
	pass
	
