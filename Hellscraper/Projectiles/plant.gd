extends Area2D


@export var damage : float = 10
@export var speed = 5
@onready var player = get_tree().get_nodes_in_group("player")

func _physics_process(delta):
	player = get_tree().get_first_node_in_group("player")
	if player:
		position = player.position
	rotation += speed * delta

func _on_fireball_body_entered(body):
	if body.is_in_group("mob"):
		body.health_manager.hurt(damage)

func _on_timer_timeout():
	queue_free()
