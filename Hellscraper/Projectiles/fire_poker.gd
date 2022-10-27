extends Area2D


@export var damage = 3.5
@export var speed = 230

var durability = 10
var duration = 0.275


func _physics_process(delta):
	duration -= delta
	if duration < 0:
		queue_free()
	position += transform.x * speed * delta


func _on_fire_poker_body_entered(body):
	if body.is_in_group("mob"):
		body.health_manager.hurt(damage)
		if durability <= 0:
			queue_free()
