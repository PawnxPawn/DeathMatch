extends Node

@onready var sfx: Node = $SFX
@onready var music: Node = $Music

func play_sfx(track: StringName) -> void:
	for sound in sfx.get_children():
		if sound.name == track and sound is AkEvent2D:
			var current_node:AkEvent2D = sound as AkEvent2D
			current_node.post_event()
			return
	print("Track not found: ", track)

func play_music(track: StringName) -> void:
	for sound in sfx.get_children():
		if sound.name == track and sound is AkEvent2D:
			var current_node:AkEvent2D = sound as AkEvent2D
			current_node.post_event()
			return
	print("Track not found: ", track)