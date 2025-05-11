extends Node2D

#region Node references
@onready var card_area: GridContainer = %CardArea
@onready var card_ref: Button = %"CardArea/CardR1C1" # TODO: Get Card Ref differently
@onready var delay_timer: Timer = $DelayTimer
@onready var sound: Node = $SoundManager
#endregion

#region Game variables
@export var score = 100
#endregion

#region Selector variables
@export_category("Selector")
@export var selector: PanelContainer
@export var selector_offset: Vector2
#endregion


#region Card tracking
var cards_at_play: Array[Button]
var found_pairs: Array[Button]
var card_compare: Array[Button]
var seen_cards: Array[Button]
#endregion

#region Initialization
func _ready() -> void:
	GameManager.reset_game()
	_initialize_game()


func _initialize_game() -> void:
	_initialize_signals()
	_initialize_cards()


func _initialize_signals() -> void:
	for child in card_area.get_children():
		child.card_flipped.connect(_flip_selected_card)
		child.mouse_entered.connect(_on_mouse_entered)
		child.mouse_exited.connect(_on_mouse_exited)
		child.animation_player.animation_finished.connect(_on_card_animation_finished)


func _initialize_cards() -> void:
	var card_ids: Array[int] = []
	var icon_pool: Array[int] = []
	var ids_to_get: int = int(card_area.get_child_count() / 2.0)
	var face_count_no_trap: int = card_ref.get_face_texture_frame_count() - 4

	for i in range(face_count_no_trap):
		icon_pool.append(i)

	for i in range(ids_to_get):
		var randomized_id = _get_id_from_pool(icon_pool)
		card_ids.append(randomized_id)
		card_ids.append(randomized_id)
	
	_assign_ids(card_ids)


func _get_id_from_pool(pool: Array[int]) -> int:
	var random_index = randi_range(0, pool.size() - 1)
	var value_to_return = pool[random_index]
	pool.erase(value_to_return)
	return value_to_return


func _assign_ids(card_ids: Array[int]) -> void:
	for child in card_area.get_children():
		if !child.should_init:
			child.disable_card()
			continue
		
		cards_at_play.append(child)
		child.update_icon_id(_get_id_from_pool(card_ids))
#endregion


#region Card interactions
func _flip_selected_card(card: Button) -> void:
	if card_compare.size() >= 2 or card.is_flipped or card.animation_player.is_playing():
		return
	
	sound.play_sfx(sound.card_flip_sfx)

	card_compare.append(card)
	selector.hide()
	card.is_flipped = true
	card.animation_player.play(&"flip_card")

	if card_compare.size() != 2:
		return

	for child in card_area.get_children():
		_enable_disable_current_cards(child)
	
	delay_timer.start()

func _on_delay_timer_timeout() -> void:
	_compare_cards()

func _compare_cards() -> void:
	if card_compare[0].icon_id == card_compare[1].icon_id:
		_cards_matched()
	else:
		_cards_dont_match()
	
	
	card_compare.clear()

	for child in card_area.get_children():
		_enable_disable_current_cards(child)
	
	if cards_at_play.size() == found_pairs.size():
		GameManager.end_game(true)

	print("Health: %d" % GameManager.health)
	print("Score: %d" % GameManager.score)
	print("Multiplier: %d" % GameManager.chain_multiplier)

func _cards_matched() -> void:
	sound.play_sfx(sound.card_good_sfx)
	for i in card_compare:
		i.disable_card()
		found_pairs.append(i)
	
	GameManager.score += score

func _cards_dont_match() -> void:
	sound.play_sfx(sound.card_bad_sfx)

	var has_seen_card: bool = false
	GameManager.chain_multiplier = 1

	for i in card_compare:
		i.flip_card_back()

		if seen_cards.find(i) != -1:
			has_seen_card = true
			continue
		
		seen_cards.append(i)
	
	if has_seen_card:
		sound.play_sfx(sound.lost_life_sfx)
		GameManager.health -= 1

func _enable_disable_current_cards(card: Button) -> void:
	if found_pairs.find(card) == -1 and card.should_init:
		card.disabled = !card.disabled
#endregion

#region Selector movement
func _on_mouse_entered() -> void:
	_move_selector()

func _on_card_animation_finished(animation_name: StringName) -> void:
	if animation_name == &"flip_card":
		_move_selector()

func _on_mouse_exited() -> void:
	pass

func _move_selector() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var node: Node

	for child in card_area.get_children():
		if child is Button and child.get_global_rect().has_point(mouse_pos) and not child.is_flipped:
			node = child
			break
	
	if node == null:
		return

	var node_center_point: Vector2 = node.get_global_rect().position
	node_center_point.x -= node.get_global_rect().size.x * .5
	node_center_point.y += node.get_global_rect().size.y * .5

	selector.set_selector_position(node_center_point, selector_offset)
	selector.show()
#endregion
