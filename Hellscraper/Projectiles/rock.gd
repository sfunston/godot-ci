extends Area2D


@export var damage = 1.5
@export var speed = 180

var durability = 6


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_rock_body_entered(body):
	if body.is_in_group("mob"):
		durability -= 1
		scale *= 0.75
		body.health_manager.hurt(damage)
		if durability <= 0:
			queue_free()
			return
		
		var all_enemy = get_tree().get_nodes_in_group("mob")
		var target
		var target_distance = 99999
		for enemy in all_enemy:
			var gun2enemy_distance = position.distance_to(enemy.position)
			if gun2enemy_distance < target_distance and enemy != body:
				target = enemy
				target_distance = gun2enemy_distance
		
		if target:
			look_at(target.position)
