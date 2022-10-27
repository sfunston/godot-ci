extends Area2D


@export var damage = 2
@export var speed = 140
@export var speed2 = 5

func _physics_process(delta):
	position += transform.x * speed * delta
	rotation += speed2 * delta


func _on_glass_shard_body_entered(body):
	if body.is_in_group("mob"):
		body.health_manager.hurt(damage)
		queue_free()


func _on_timer_timeout():
	queue_free()
