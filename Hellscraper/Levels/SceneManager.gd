extends Node


@export var music: Dictionary

@onready var current_scene = $GameLevel
@onready var audio_stream_player = $AudioStreamPlayer

var scene_mapper = {
	"main_menu": "res://Menu/mainMenu.tscn",
	"day": "res://Levels/game_level.tscn",
	"night": "res://Levels/night_level.tscn",
	"boss": "res://Levels/boss_level.tscn",
	"credits": "res://Levels/credits.tscn",
	"game_over": "res://Menu/game_over.tscn",
}
#var saved_day_scene_path = "res://Levels/__saved_day_scene.tscn"
var saved_day_scene
var day_is_saved_to_path := false

func _ready():
	GameManager.connect("scene_changed", update_scene)


func update_scene(scene_key: String):
	$FadeToBlackCanvas.connect("faded_to_black", finish_updating_scene.bind(scene_key))
	$FadeToBlackCanvas.transition()


func finish_updating_scene(scene_key: String):
	if GameManager.is_day():
		save_day_scene()
		
		var solved = check_solution()
		if solved:
			scene_key = "boss"
	
	GameManager.change_gameplay_stage(scene_key)
	var next_scene = get_next_scene(scene_key)
	add_child(next_scene)
	current_scene.queue_free()
	current_scene = next_scene
	$FadeToBlackCanvas.disconnect("faded_to_black", finish_updating_scene.bind(scene_key))
	
	$AudioStreamPlayer.stream = music[scene_key]
	$AudioStreamPlayer.playing = true
	
func get_next_scene(scene_key: String):
	var next_scene
	
	if scene_key == "day" and day_is_saved_to_path:
		# next scene is day and we have a saved day scene
		next_scene = load_day_scene()
	else:
		# get next scene normally
		next_scene = load(scene_mapper[scene_key]).instantiate()
	
	return next_scene

func save_day_scene():
	# We want to preserve the state of the day scene
	# So if current_scene is day, pack and save it.
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_node("GameLevel"))
	saved_day_scene = packed_scene
#	ResourceSaver.save(packed_scene, saved_day_scene_path)
	
	day_is_saved_to_path = true

func load_day_scene():
	# We want to preserve the state of the day scene
	# So if next_scene is day, pack and save it.
	
	# Load the PackedScene resource
	var packed_scene = saved_day_scene.instantiate()
	return packed_scene

func check_solution():
	var wants = GameManager.wanted_items
	var haves_objs = GameManager.item_array
	
	var haves = []
	for haves_obj in haves_objs:
		if haves_obj:
			haves.append(haves_obj.name)
	
#	print("wanted items: ", wants, " \ncurrent items: ", haves)
	
	for want in wants:
		if want not in haves:
			return false
	
	return true
