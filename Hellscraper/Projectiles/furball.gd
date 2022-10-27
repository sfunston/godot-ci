extends Area2D


@export var damage = 3
@export var speed = 80

var split_angle = 0.33
var durability = 2
var summon_sickness = 0.35

var projectile = load("res://Projectiles/furball.tscn")

func _physics_process(delta):
	summon_sickness -= delta
	position += transform.x * speed * delta


func _on_furball_body_entered(body):
	if summon_sickness < 0:
		if body.is_in_group("mob"):
			body.health_manager.hurt(damage)
			if durability > 0:
				create_another_furball(split_angle)
				create_another_furball(-split_angle)
			queue_free()

func create_another_furball(angle: float):
	var P = projectile.instantiate()
	var level = get_tree().get_first_node_in_group("game level")
	level.add_child(P)
	
	P.position = position
	P.rotation = rotation
	P.durability = durability - 1
	P.scale = scale * 0.8
	
	P.rotate(angle)
