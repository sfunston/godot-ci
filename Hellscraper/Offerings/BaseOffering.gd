extends StaticBody2D

class_name BaseOffering

var picked = false
var locked = false
var active = false
var time_until_fire_weapon
var single_shooter

@export var cooldown = 0.3
@export var projectile = preload("res://Projectiles/fireball.tscn")

func _ready():
	var solved_item_names: Array = []
	for item in GameManager.item_array:
		if item:
			solved_item_names.append(item.name)
		else:
			solved_item_names.append(null)

	if name in GameManager.wanted_items and name in solved_item_names:
		locked = true
		GameManager.locked_items[solved_item_names.find(name)] = true
	
	single_shooter = cooldown > 1000
	time_until_fire_weapon = cooldown

func _process(delta):
	time_until_fire_weapon -= delta
	if time_until_fire_weapon < 0 and active:
		fireWeapon()
		time_until_fire_weapon = cooldown
	
	var age = cooldown - time_until_fire_weapon
	if active and single_shooter and age > 1:
		fireWeapon()
		active = false

func _physics_process(delta):
	if picked == true:
		self.position = get_node("../NavigationRegion2d/Player/Position").global_position

func _input(event):
	if Input.is_action_just_pressed("pickup") and GameManager.is_day():
		var bodies = $Area2d.get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player":
				if body.canPick == true and !locked:
					picked = true
					body.canPick = false
					get_node("CollisionShape2d").disabled = true
				elif picked == true:
					picked = false
					body.canPick = true
					get_node("CollisionShape2d").disabled = false

func fireWeapon():
	var P = projectile.instantiate()
	var level = get_tree().get_first_node_in_group("game level")
	level.add_child(P)
	
	P.position = position
	var all_enemy = get_tree().get_nodes_in_group("mob")
	var target
	var target_distance = 99999
	for enemy in all_enemy:
		var gun2enemy_distance = position.distance_to(enemy.position)
		if gun2enemy_distance < target_distance:
			target = enemy
			target_distance = gun2enemy_distance
	
	if target:
		P.look_at(target.position)

