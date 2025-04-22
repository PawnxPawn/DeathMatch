extends Control

@export var main_menu: PackedScene
@export var settings_menu: PackedScene


func _on_resume_button_pressed() -> void:
	pass #TODO: Write logic to hide this.

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)

func _on_settings_button_pressed() -> void:
	pass #TODO: Write logic to hide this and show settings menu


    
