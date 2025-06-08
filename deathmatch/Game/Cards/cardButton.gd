extends Button

# Compare two cards using the icon_id
# After two cards are flipped.
signal card_flipped(Button)

## Frame to use for the FaceTexture Node
@export var icon_id:int = 0
## Initialize card?
@export var should_init:bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var face_texture: TextureSpriteFrames = $CardTexture/FaceTexture
@onready var card_texture: TextureSpriteFrames = $CardTexture

enum TrapCard {
	TRAP_LOSE_TIME = 18,
	TRAP_RESHUFFLE = 19,
	TRAP_HEAL = 20,
	TRAP_LOSE_LIFE = 21,
}

var is_flipped:bool = false
var is_trap_card:bool = false
var trap_card_index_start:int = 18

var card_count = 0


func _ready() -> void:
	card_count += 1
	update_icon_id(icon_id)


func get_face_texture_frame_count() -> int:
	return face_texture.sprite_frames.get_frame_count(&"icons")


func update_icon_id(id:int) -> void:
	icon_id = id
	face_texture.frame_index = icon_id


func flip_card_back() -> void:
	is_flipped = false
	animation_player.play_backwards(&"flip_card")
	await animation_player.animation_finished


func disable_card() -> void:
	card_texture.visible = false
	disabled = true


# Emits a custom signal with the card that was clicked
func _on_clicked() -> void:
	card_flipped.emit(self)
