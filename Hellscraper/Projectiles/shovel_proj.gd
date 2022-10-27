extends Area2D


@export var damage = 2
@export var speed = 184



func _physics_process(delta):
	position += transform.x * speed * delta


func _on_shovel_proj_body_entered(body):
	if body.is_in_group("mob"):
		body.health_manager.hurt(damage)
		queue_free()
