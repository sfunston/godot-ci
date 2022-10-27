extends Area2D


@export var damage = 1
@export var speed = 120


func _ready():
	$Sprite2d.frame = randi_range(0, 3)

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_coin_body_entered(body):
	if body.is_in_group("mob"):
		body.health_manager.hurt(damage)
		queue_free()
