extends Control

@export var level_0: PackedScene
@export var settings_menu: PackedScene


func _on_play_game_button_pressed() -> void:
    get_tree().change_scene_to_packed(level_0)
    

func _on_settings_button_pressed() -> void:
    pass #TODO: Write logic to hide this and show settings menu


func _on_exit_button_pressed() -> void:
    get_tree().quit()

