extends Node2D

class_name HealthManager

var max_health
@export var cur_health = 10.0
@export var dead = false

@onready var hp_bar = $healthbar/ProgressBar

signal health_changed
signal dead_signal
signal hurt_signal

func _ready():
	max_health = cur_health

func init():
	emit_signal("health_changed", cur_health)
	emit_signal("dead_signal", dead)

func hurt(damage: int):
	if cur_health < 0:
		return
	cur_health -= damage
	update_hp_bar()
	if cur_health < 0:
		dead = true
		emit_signal("dead_signal")
	else:
		emit_signal("hurt_signal")
	emit_signal("health_changed", cur_health)

func update_hp_bar():
	hp_bar.value = cur_health / max_health
