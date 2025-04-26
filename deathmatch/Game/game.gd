extends Node2D

@onready var card_area: GridContainer = $"PlayArea/CardField/Card Area"
@onready var card_ref: Button = $"PlayArea/CardField/Card Area/CardR1C1" # Should get this info a diffrent way
@onready var delay_timer: Timer = $DelayTimer

@export var score = 100

var cards_at_play:Array[Button]
var found_pairs:Array[Button]
var card_compare:Array[Button]
var seen_cards:Array[Button]

func _ready() -> void:
	_initialize_cards()


#Initialize the cards icons and values
func _initialize_cards() -> void:
	# Connect all cards card_flipped signal
	for child in card_area.get_children():
		child.card_flipped.connect(_check_card,)
	
	# Pool of possible card IDs
	var value: Array[int] = []
	var icon_pool: Array[int] = []
	var values_to_get: int = int(card_area.get_child_count() / 2.0)

	for i in range(card_ref.get_face_texture_frame_count()):
		icon_pool.append(i)

	for i in range(values_to_get):
		var randomized_value = _get_value_from_pool(icon_pool)
		value.append(randomized_value)
		value.append(randomized_value)
	print(value)
	
	# Assign cards a ID
	for child in card_area.get_children():
		if child.should_init:
			cards_at_play.append(child)
			child.update_icon_id(_get_value_from_pool(value))
		else:
			child.disable_card()


# Fetch and remove a value from the pool
func _get_value_from_pool(pool: Array[int]) -> int:
	var random_index = randi_range(0, pool.size() - 1)
	var value_to_return = pool[random_index]
	pool.erase(value_to_return)
	return value_to_return


# Keep list of completed 
func _enable_disable_current_cards(card:Button) -> void:
	if found_pairs.find(card) == -1 and card.should_init: 
		card.disabled = !card.disabled


func _check_card(card:Button) -> void:
	
	if card_compare.size() >= 2 or card.is_flipped or card.animation_player.is_playing(): return
	
	# Add card to arrays
	card_compare.append(card)
	
	# Mark card as flipped
	card.is_flipped = true
	card.animation_player.play(&"flip_card")
	
	if card_compare.size() != 2: return
	
	# Disable cards buttom
	for child in card_area.get_children():
		_enable_disable_current_cards(child)
	
	delay_timer.start()


func _on_delay_timer_timeout() -> void:
	if card_compare[0].icon_id == card_compare[1].icon_id:
		# Hides cards then adds cards to a found pair array
		for i in card_compare:
			i.disable_card()
			found_pairs.append(i)
		GameManager.score += score
	else:
		# Checks if cards have been seen if not adds them to an array
		# else takes a life
		GameManager.chain_multiplier = 1
		var has_seen_card:bool = false
		for i in card_compare:
			i.flip_card_back()
			if seen_cards.find(i) != -1:
				has_seen_card = true
			else:
				seen_cards.append(i)
		
		if has_seen_card:
			GameManager.health -= 1
	
	card_compare.clear()
	
	#Re-Enables active cards
	for child in card_area.get_children():
		_enable_disable_current_cards(child)
	
	if cards_at_play.size() == found_pairs.size():
		GameManager.game_won()
		print("Game Won")
	
	print("Health: %d" % GameManager.health)
	print("Score: %d" % GameManager.score)
	print("Multiplier: %d" % GameManager.chain_multiplier)
