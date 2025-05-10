extends Node

@onready var sfx: Node = $SFX
@onready var music: Node = $Music

#SFX Tracks
var test_sfx: StringName  = &"TestTone"
var card_bad_sfx: StringName  = &"CardBadSound"
var card_good_sfx: StringName  = &"CardGoodSound"
var card_flip_sfx: StringName  = &"TestTone"
var lost_life_sfx: StringName  = &"LostLife"
var hover_sfx: StringName  = &"HoverTone"

#Music Tracks
var main_menu_music: StringName  = &"MainMenu"
var game_music: StringName  = &"GameMusic"
var game_music_double_time: StringName  = &"GameMusicDoubleTime"
var game_over_music: StringName  = &"GameOver"
var game_win_music: StringName  = &"GameWin"


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