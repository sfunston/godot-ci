extends Node2D

var time_until_spawn

@export var cooldown = 10.0
@export var monster = preload("res://Characters/monster.tscn")


func _ready():
	spawn_enemy()
	time_until_spawn = cooldown

func _process(delta):
	time_until_spawn -= delta
	if time_until_spawn < 0:
		spawn_enemy()
		time_until_spawn = cooldown


func spawn_enemy():
	var nav_region = get_node("../NavigationRegion2d")
	var new_monster = monster.instantiate()
	nav_region.call_deferred("add_child", new_monster)
	
	new_monster.position = position
