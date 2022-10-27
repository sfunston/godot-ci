extends Monster

# inherits from monster so like we chillin?



func set_state_dead():
	# special boss dying function
	cur_state = STATES.DEAD
	dead = true
	$CollisionShape2d.disabled = true
	
	GameManager.set_to_credits()
