extends Control

@onready var level_0 = "res://Game/Game.tscn"
@onready var credits = "uid://bvcy6tqectio2" #credits.tscn
@onready var vbox_container: VBoxContainer = %MenuContainer
@onready var difficulty_button: Button = %Difficulty
@onready var sound: Node = $SoundManager

@export var settings_menu: Control
@export var main_menu_control: Control

@export_category("Selector")
@export var selector: PanelContainer
@export var selector_offset: Vector2

var _is_setup = false


func _ready() -> void:
	difficulty_button.text = GameManager.get_game_difficulty
	_is_setup = true


func _on_play_game_button_pressed() -> void:
	get_tree().change_scene_to_file(level_0)
	

func show_hide() -> void:
	main_menu_control.visible = !main_menu_control.visible
	settings_menu.visible = !settings_menu.visible


func _on_hover_set_selector() -> void:
	if not _is_setup: return

	sound.play_sfx(sound.hover_sfx)
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var node: Node
	
	for child in %MenuContainer.get_children():
		if child is Button and child.get_global_rect().has_point(mouse_pos):
			node = child
			break

	if not node: return
		
	var node_center_point: Vector2 = node.get_global_rect().position
	node_center_point.x -= node.get_global_rect().size.x

	selector.set_selector_position(node_center_point, selector_offset)
	selector.show()

func _change_difficulty() -> void:
	GameManager.update_difficulty()
	difficulty_button.text = GameManager.get_game_difficulty

func _on_settings_button_pressed() -> void:
	selector.hide()
	show_hide()


func _on_settings_menu_return_control() -> void:
	show_hide()


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file(credits)


func _on_play_game_button_mouse_entered() -> void:
	_on_hover_set_selector()
	


func _on_settings_button_mouse_entered() -> void:
	_on_hover_set_selector()
	

func _on_credits_button_mouse_entered() -> void:
	_on_hover_set_selector()
	
