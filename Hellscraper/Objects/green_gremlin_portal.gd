extends Node2D

var time_until_spawn

@export var cooldown = 5.0
@export var enemies_to_spawn = 10
@export var monster = preload("res://Characters/monster.tscn")
var rng = RandomNumberGenerator.new()


func _ready():
	time_until_spawn = cooldown

func _process(delta):
	time_until_spawn -= delta
	if time_until_spawn < 0:
		spawn_enemy()
		spawn_enemy()
		spawn_enemy()
		spawn_enemy()
		spawn_enemy()
		spawn_enemy()
		spawn_enemy()
		spawn_enemy()
		spawn_enemy()
		spawn_enemy()
		time_until_spawn = cooldown


func spawn_enemy():
	var nav_region = get_node("../NavigationRegion2d")
	var new_monster = monster.instantiate()
	nav_region.call_deferred("add_child", new_monster)
	rng.randomize()
	var my_random_number = rng.randf_range(-5.0, 5.0)
	new_monster.position = position + Vector2(my_random_number, my_random_number)
