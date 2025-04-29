extends Control

# Tell game the timer has ended
signal timed_out 

## Wait time for timer
@export var timer_wait_time:float = 30.0

@onready var game_timer: Timer = $GameTimer
@onready var texture_progress_bar: TextureProgressBar = %FuseTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fuse_path_follow: PathFollow2D = %SparkFusePath
# Set wait time then start the timer
func _ready() -> void:
	game_timer.wait_time = timer_wait_time
	game_timer.start()


# Set the timers percentage then 
func _process(_delta: float) -> void:
	var timer_percentage = game_timer.time_left / timer_wait_time
	texture_progress_bar.value = timer_percentage
	fuse_path_follow.progress_ratio = timer_percentage - .01

func _on_game_timer_timeout() -> void:
	animation_player.play(&"explode")

func emit_timed_out() -> void:
	timed_out.emit()
