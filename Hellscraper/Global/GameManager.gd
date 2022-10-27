extends Node


enum game_states {First_Night, Day, Night, Boss, Credits, GameOver}

@export var gameplay_stage: game_states

var _penta_item_positions: Array = [null, null, null, null, null]
var item_array: Array = [null, null, null, null, null]
var locked_items: Array = [false, false, false, false, false]

var wanted_items = null

signal scene_changed


func set_to_first_night():
	# prob handled in scene manager? don't need special calls
	pass

func set_to_day():
	emit_signal("scene_changed", "day")

func set_to_night():
	emit_signal("scene_changed", "night")

func set_to_credits():
	emit_signal("scene_changed", "credits")

func set_to_game_over():
	emit_signal("scene_changed", "game_over")

func change_gameplay_stage(scene_key: String):
	var mapper = {
		"day": game_states.Day,
		"night": game_states.Night,
		"boss": game_states.Boss,
		"credits": game_states.Credits,
		"game_over": game_states.GameOver,
	}
	_change_gameplay_stage(mapper[scene_key])

func _change_gameplay_stage(new_stage: game_states):
	gameplay_stage = new_stage

func is_first_night():
	return gameplay_stage == game_states.First_Night

func is_day():
	return gameplay_stage == game_states.Day

func is_night():
	return gameplay_stage == game_states.Night

func is_boss():
	return gameplay_stage == game_states.Boss

func is_combat_time():
	return is_boss() or is_night()

func reset_globals():
	_penta_item_positions = [null, null, null, null, null]
	item_array = [null, null, null, null, null]
	locked_items = [false, false, false, false, false]

	wanted_items = null
	gameplay_stage = game_states.Day
