@tool
class_name TextureSpriteFrames extends TextureRect

# Allows for sprite frames to be used in TextureRect
@export var sprite_frames:SpriteFrames
@export var current_animation:StringName = &"default"
@export var frame_index:int = 0

#Storage to make sure things haven't change
var _last_frame_index:int = frame_index
var _last_animation:StringName = current_animation

func _ready() -> void:
	set_texture_to_frame(current_animation)


func _process(_delta: float) -> void:
	set_texture_to_frame(current_animation)


func set_texture_to_frame(animation_name:StringName):
	if frame_index != _last_frame_index or animation_name != _last_animation:
		_last_animation = current_animation
		_last_frame_index = frame_index
		texture = sprite_frames.get_frame_texture(current_animation, frame_index)


func visibility_flip() -> void:
	visible = !visible
