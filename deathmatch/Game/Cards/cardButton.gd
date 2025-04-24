extends Button

@export var icon_id:int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var face_texture: TextureSpriteFrames = $CardTexture/FaceTexture

var is_flipped:bool = false

func _ready() -> void:
	face_texture.frame_index = icon_id

func _on_pressed() -> void:
	if not is_flipped and not animation_player.is_playing():
		is_flipped = true
		animation_player.play("flip_card")
		#NOTE: use play_backward to flip card back over.
