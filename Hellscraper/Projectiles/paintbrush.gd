extends Area2D


@export var damage = 1
@export var speed = 200
@onready var paint_particles = $PaintParticles


func _physics_process(delta):
	position += transform.x * speed * delta
	rotation += 3 * delta

func _on_fireball_body_entered(body):
	if body.is_in_group("mob"):
		body.health_manager.hurt(damage)

func _on_timer_timeout():
	queue_free()
