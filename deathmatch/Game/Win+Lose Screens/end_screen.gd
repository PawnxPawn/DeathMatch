extends Control

@onready var end_screen_image: TextureSpriteFrames = %EndScreenImage

func _ready() -> void:
    _check_end_state()

func _input(_event: InputEvent) -> void:
    if (Input.is_action_just_pressed("Pause")):
        get_tree().quit()


func _check_end_state() -> void:
    end_screen_image.current_animation = "win" if GameManager.has_won_game else "lose"