extends Button

# Compare two cards using the icon_id
# After two cards are flipped.
signal card_flipped(Button)

## Frame to use for the FaceTexture Node
@export var icon_id:int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var face_texture: TextureSpriteFrames = $CardTexture/FaceTexture
@onready var card_texture: TextureSpriteFrames = $CardTexture

var is_flipped:bool = false

func _ready() -> void:
	update_icon_id(icon_id)


## Gets the sprite frames count  from the face texture
func get_face_texture_frame_count() -> int:
	return face_texture.sprite_frames.get_frame_count(&"icons")


## Updates the icon on card
func update_icon_id(id:int) -> void:
	icon_id = id
	face_texture.frame_index = icon_id


func flip_card_back() -> void:
	is_flipped = false
	animation_player.play_backwards(&"flip_card")


func disable_card() -> void:
	card_texture.visible = false
	disabled = true


func _on_clicked() -> void:
	card_flipped.emit(self)
