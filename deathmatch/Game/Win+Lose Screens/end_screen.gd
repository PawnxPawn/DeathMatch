extends Control

@onready var end_screen_image: TextureSpriteFrames = %EndScreenImage
@onready var credits_player: AnimationPlayer = %CreditsPlayer
@onready var main_menu_scene: StringName = &"uid://bdmlspewkwo5s"
@onready var delay_timer: Timer = $DelayTimer
@onready var credits: Control = $Credits

var _is_credits_on_screen: bool = false
var _is_changing_scenes: bool = false

func _ready() -> void:
	_is_changing_scenes = false
	if AudioManager.game_music.is_playing():
		AudioManager.game_music.stop()
	_check_end_state()
	_play_animation()


func _input(_event: InputEvent) -> void:
	if Input.is_anything_pressed() and not _is_changing_scenes:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_is_changing_scenes = true
			if not GameManager.is_credits_called:
				await _fade_out_animation()
			credits.modulate = Color.hex(0xffffff00)
			get_tree().change_scene_to_file(main_menu_scene)


func _fade_out_animation() -> void:
	credits_player.play("FullEndSceneFadeOut")
	await credits_player.animation_finished


func _play_animation() -> void:
	if GameManager.is_credits_called:
		print("Credits called")
		GameManager.is_credits_called = false
		_is_credits_on_screen = false
		credits.modulate = Color.hex(0xffffffff)
		return
	
	credits_player.play("EndScreenFadeIn")
	delay_timer.start()


func _start_credits() -> void:
	if not _is_credits_on_screen:
		_is_credits_on_screen = true
		credits_player.play("CreditsFadeIn")
		delay_timer.start()
		return
	
	if not _is_changing_scenes:
		_is_changing_scenes = true
		await _fade_out_animation()
		_is_credits_on_screen = false
		credits.modulate = Color.hex(0xffffff00)
		get_tree().change_scene_to_file(main_menu_scene)


func _check_end_state() -> void:
	if not GameManager.is_credits_called:
		if GameManager.has_won_game:
			AudioManager.win_jingle_music.play()
		else:
			AudioManager.lose_jingle_music.play()
	end_screen_image.visible = not GameManager.is_credits_called
	end_screen_image.current_animation = "win" if GameManager.has_won_game else "lose"
