extends Node2D


@onready var camera = $Camera2d


func _ready():
	camera.current = true
