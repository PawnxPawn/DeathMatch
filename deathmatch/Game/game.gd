extends Node2D

#region Node references
@onready var card_area: GridContainer = %CardArea
@onready var card_ref: Button = %"CardArea/CardR1C1" # TODO: Get Card Ref differently
@onready var game_player: AnimationPlayer = %GamePlayer
@onready var delay_timer: Timer = $DelayTimer
@onready var sound: Node = $SoundManager
#endregion

#region Game variables
@export var score: int = 100
@export_range(0, 24, 2) var trap_card_count: int = 4
#endregion

#region Selector variables
@export_category("Selector")
@export var selector: PanelContainer
@export var selector_offset: Vector2
#endregion


#region Card tracking
var cards_at_play: Array[Button]
var cards_left_on_field: Array[Button]
var found_pairs: Array[Button]
var card_compare: Array[Button]
var seen_cards: Array[Button]
var traps_at_play: Array[Button]
var trap_to_remove: Button
var removed_trap_cards: Array[Button]
#endregion

#region logic variables
var should_handle_trap: bool = false
#endregion


#region Initialization
func _ready() -> void:
	GameManager.reset_game()
	_initialize_game()


func _initialize_game() -> void:
	_initialize_signals()
	_initialize_cards()
	game_player.play("GameFadeIn")


func _initialize_signals() -> void:
	for child in card_area.get_children():
		child.card_flipped.connect(_flip_selected_card)
		child.mouse_entered.connect(_on_mouse_entered)
		child.mouse_exited.connect(_on_mouse_exited)
		child.animation_player.animation_finished.connect(_on_card_animation_finished)


func _initialize_cards() -> void:
	var card_ids: Array[int] = []
	var icon_pool: Array[int] = []
	var ids_to_get: int = int((card_area.get_child_count() - _get_trap_card_count()) / 2.0)
	var face_count_no_trap: int = card_ref.get_face_texture_frame_count() - 4

	if ids_to_get > 0:
		for i in face_count_no_trap:
			icon_pool.append(i)

		for i in ids_to_get:
			var randomized_id = _get_id_from_pool(icon_pool)
			card_ids.append(randomized_id)
			card_ids.append(randomized_id)
	
	if GameManager.difficulty >=1:
		for i in trap_card_count:
			card_ids.append(_set_trap_cards())

	_assign_ids(card_ids)


func _get_trap_card_count() -> int:
	if GameManager.difficulty >= 1:
		return trap_card_count
	else:
		return 0
	

func _set_trap_cards() -> int:
	var random_int:int = randi_range(card_ref.trap_card_index_start, card_ref.get_face_texture_frame_count() -1)
	while random_int == 18:
		random_int = randi_range(card_ref.trap_card_index_start, card_ref.get_face_texture_frame_count() -1)
	return random_int


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

		child.update_icon_id(_get_id_from_pool(card_ids))
		if child.icon_id >= child.trap_card_index_start:
			traps_at_play.append(child)
		else:
			cards_at_play.append(child)

		if child.icon_id >= card_ref.trap_card_index_start:
			child.is_trap_card = true
	cards_left_on_field = cards_at_play.duplicate()
	if traps_at_play.size() > 0:
		for c in traps_at_play:
			print(c, ": ", c.icon_id)
			cards_left_on_field.append(c)

#endregion


#region Card interactions
func _flip_selected_card(card: Button) -> void:
	if card_compare.size() >= 2 or card.is_flipped or card.animation_player.is_playing():
		return
	
	sound.play_sfx(sound.card_flip_sfx)

	selector.hide()
	card.is_flipped = true
	card.animation_player.play(&"flip_card")

	if card.is_trap_card:
		_run_trap_card(card)
		return

	card_compare.append(card)

	if card_compare.size() != 2:
		return

	for child in card_area.get_children():
		_enable_disable_current_cards(child)
	
	delay_timer.start()


func _run_trap_card(card: Button) -> void:
	should_handle_trap = true
	
	for child in card_area.get_children():
		_enable_disable_current_cards(child)
	
	trap_to_remove = card

	match card.icon_id:
		card.TrapCard.TRAP_LOSE_TIME:
			print("Lose time trap card")
			#_lose_time()
		card.TrapCard.TRAP_RESHUFFLE:
			print("Reshuffle trap card")
			await _check_if_card_animation_is_playing(card)
			_reshuffle_cards()
		card.TrapCard.TRAP_HEAL:
			print("Heal trap card")
			GameManager.health += 1
		card.TrapCard.TRAP_LOSE_LIFE:
			print("Lose life trap card")
			GameManager.health -= 1


	delay_timer.start()


func _check_if_card_animation_is_playing(card:Button) -> void:
	if card.animation_player.is_playing():
		await card.animation_player.animation_finished


func _reshuffle_cards() -> void:
	var card_pool_id: Array[int]

	if not card_compare.is_empty():
		for child in card_compare:
			if child.is_flipped and not child.is_trap_card:
				await child.flip_card_back()
		card_compare.clear()

	seen_cards.clear()

	for card in cards_left_on_field:
		if not card.is_flipped:
			card_pool_id.append(card.icon_id)
	

	for child in cards_left_on_field:
		if child == trap_to_remove: continue
		child.update_icon_id(_get_id_from_pool(card_pool_id))
		child.is_trap_card = child.icon_id >= card_ref.trap_card_index_start


func _on_delay_timer_timeout() -> void:
	if should_handle_trap:
		_handle_trap_card()
		return

	_compare_cards()


func _handle_trap_card() -> void:
	trap_to_remove.disable_card()
	removed_trap_cards.append(trap_to_remove)
	cards_left_on_field.erase(trap_to_remove)

	for child in card_area.get_children():
		_enable_disable_current_cards(child)
	
	should_handle_trap = false


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
		cards_left_on_field.erase(i)
	
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
	if found_pairs.find(card) == -1 and removed_trap_cards.find(card) == -1 and card.should_init:
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
