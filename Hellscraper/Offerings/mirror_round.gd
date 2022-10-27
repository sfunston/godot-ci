extends BaseOffering


func fireWeapon():
	for proj_num in range(0, 3):
		var modifier = proj_num - 1
		
		var P = projectile.instantiate()
		var level = get_tree().get_first_node_in_group("game level")
		level.add_child(P)
		
		P.position = position
		var all_enemy = get_tree().get_nodes_in_group("mob")
		var target
		var target_distance = 99999
		for enemy in all_enemy:
			var gun2enemy_distance = position.distance_to(enemy.position)
			if gun2enemy_distance < target_distance:
				target = enemy
				target_distance = gun2enemy_distance
		
		if target:
			P.look_at(target.position)
		
		# spray randomly
		var rotated_variation = (randf() * 0.8) + (0.4 * modifier)
		P.rotate(rotated_variation)
