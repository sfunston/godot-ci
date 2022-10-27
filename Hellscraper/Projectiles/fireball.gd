extends Area2D


@export var damage = 3
@export var speed = 100



func _physics_process(delta):
	position += transform.x * speed * delta


func _on_fireball_body_entered(body):
	if body.is_in_group("mob"):
		body.health_manager.hurt(damage)
		queue_free()
