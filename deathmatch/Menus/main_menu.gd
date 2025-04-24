extends Control

@export var level_0: PackedScene
@export var settings_menu: Control
@export var main_menu_control: Control


func _on_play_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(level_0)
	

func show_hide() -> void:
	main_menu_control.visible = !main_menu_control.visible
	settings_menu.visible = !settings_menu.visible

func _on_settings_button_pressed() -> void:
	show_hide()

func _on_settings_menu_return_control() -> void:
	show_hide()

func _on_exit_button_pressed() -> void:
	get_tree().quit()


