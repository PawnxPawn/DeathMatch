#TODO: Add multiline printing
@tool
extends Control

@onready var alphabet_scene:PackedScene = preload("uid://dujnx5rlqblmx")

@export var text: String = "Hello World"
@export var font_size: int = 32
@export var seperation: int

var _text_frame_indexs: Array[int]
var _default_seperation: int = -86
var _current_hbox:HBoxContainer

func _ready() -> void:
	_string_to_png()


func _string_to_png() -> void:
	_set_alphabet_to_frame_index()
	_add_hbox()
	_add_letters()


func _set_alphabet_to_frame_index() -> void:
	for c in text:
		_text_frame_indexs.append(AlphabetToFrame._get_character_frame_index(c))
	


func _add_hbox() -> void:
	var text_line: HBoxContainer = HBoxContainer.new()
	var separation_total: int = _default_seperation + seperation
	var size_percentage = font_size/100.0
	var new_size:Vector2 = Vector2(size_percentage, size_percentage)
	
	text_line.scale = new_size
	text_line.name = "Line"
	text_line.add_theme_constant_override("separation", separation_total)
	add_child(text_line)
	_current_hbox = text_line


func _add_letters() -> void:
	var count_loop:int = 0
	
	for i in _text_frame_indexs:
		_letter_to_frame(i, text[count_loop])
		count_loop += 1


func _letter_to_frame(letter_index:int, letter:String = "") -> void:
	var letter_sprite_frame: TextureSpriteFrames = alphabet_scene.instantiate()

	letter_sprite_frame.frame_index = letter_index
	letter_sprite_frame.name = letter + " Letter"
	_current_hbox.add_child(letter_sprite_frame)
