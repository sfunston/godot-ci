extends Node2D

@onready var tile_map : TileMap = %TileMap

func _process(delta):
	var bodies = $Area2d.get_overlapping_bodies()
	var player_entered = false
	for body in bodies:
		if body.name == "Player":
			player_entered = true
	tile_map.set_layer_enabled(4, !player_entered)
