extends Control

# Tell game the timer has ended
signal timed_out 

## Wait time for timer
@export var timer_wait_time:float = 30.0
@export var spark_lead_offset:float = 0.018

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
	var timer_percentage:float = game_timer.time_left / timer_wait_time
	var timer_percentage_spark:float = timer_percentage - spark_lead_offset
	
	texture_progress_bar.value = timer_percentage
	fuse_path_follow.progress_ratio = 0.0 if timer_percentage_spark <= 0.0 else timer_percentage_spark

func _on_game_timer_timeout() -> void:
	animation_player.play(&"explode")

func emit_timed_out() -> void:
	timed_out.emit()
