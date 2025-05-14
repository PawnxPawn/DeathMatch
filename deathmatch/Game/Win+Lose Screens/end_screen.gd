extends Control

@onready var end_screen_image: TextureSpriteFrames = %EndScreenImage
@onready var credits_player: AnimationPlayer = %CreditsPlayer
@onready var main_menu_scene: StringName = &"uid://bdmlspewkwo5s"
@onready var delay_timer: Timer = $DelayTimer

var _is_credits_on_screen = false

func _ready() -> void:
	_connect_signals()
	_check_end_state()
	_play_animation()


func _connect_signals() -> void:
	pass


func _input(_event: InputEvent) -> void:
	if Input.is_anything_pressed():
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			await _fade_out_animation()
			get_tree().change_scene_to_file(main_menu_scene)


func _fade_out_animation() -> void:
	credits_player.play("FullEndSceneFadeOut")
	await credits_player.animation_finished


func _play_animation() -> void:
	if GameManager.is_credits_called:
		GameManager.is_credits_called = false
		_is_credits_on_screen = false
		credits_player.play("CreditsFadeIn")
		return
	
	credits_player.play("EndScreenFadeIn")
	delay_timer.start()


func _start_credits() -> void:
	if not _is_credits_on_screen:
		_is_credits_on_screen = true
		credits_player.play("CreditsFadeIn")
		delay_timer.start()
		return
	
	await _fade_out_animation()
	_is_credits_on_screen = false
	get_tree().change_scene_to_file(main_menu_scene)


func _check_end_state() -> void:
	end_screen_image.visible = not GameManager.is_credits_called
	end_screen_image.current_animation = "win" if GameManager.has_won_game else "lose"
