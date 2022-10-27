extends CharacterBody2D

class_name Monster

@onready var health_manager = $HealthManager
@onready var nav : NavigationRegion2D = get_parent()

enum STATES {IDLE, CHASE, ATTACK, DEAD}

@export var cur_state = STATES

var player = null
var path = []

@export var SPEED = 1.0

var sight_angle = 360.0
var turn_speed = 0

@export var attack_damage = 2.5
var attack_angle = 360.0
@export var attack_range = 30.0
var attack_rate = .1
var attack_timer : Timer
var can_attack = true
var dead = false

signal attack
signal dead_signal

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.timeout.connect(self.finish_attack)
	attack_timer.one_shot = true
	add_child(attack_timer)
	
	player = get_node("../Player")
	
	health_manager.dead_signal.connect(self.set_state_dead)
	
	set_state_chase()

func _process(delta):
	match cur_state:
		STATES.IDLE:
			process_state_idle(delta)
		STATES.CHASE:
			process_state_chase(delta)
		STATES.ATTACK:
			process_state_attack(delta)
		STATES.DEAD:
			process_state_dead(delta)

func set_state_idle():
	cur_state = STATES.IDLE

func set_state_chase():
	cur_state = STATES.CHASE

func set_state_attack():
	cur_state = STATES.ATTACK

func set_state_dead():
	cur_state = STATES.DEAD
	dead = true
	$CollisionShape2d.disabled = true

func process_state_idle(delta):
	if can_see_player():
		set_state_chase()

func process_state_chase(delta):
	if within_dis_of_player(attack_range) and has_los_player():
		set_state_attack()
	var player_pos = player.global_transform.origin
	var our_pos = global_transform.origin
	path = nav.get_path_to(player)
	
	var goal_pos = player_pos
	
	var dir = player.transform.origin - our_pos
#	dir.y = 0
#	character_mover.set_move_vec(dir)
	face_direction(dir, delta)
	
	if dir:
		velocity.x = dir.x * SPEED
		velocity.y = dir.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func process_state_attack(delta):
#	character_mover.set_move_vec(Vector3.ZERO)
	
	#face_dir(global_transform.origin.direction_to(player.global_transform.origin), delta)
	if can_attack:
		if !within_dis_of_player(attack_range):# or !can_see_player():
			set_state_chase()
		elif !player_within_angle(attack_angle):
				face_direction(global_transform.origin.direction_to(player.global_transform.origin), delta)
		else:
			start_attack()
#			print("attacking!")
			player.health_manager.hurt(attack_damage)

func process_state_dead(delta):
	dead = true
	queue_free()

func finish_attack():
	can_attack = true
	
func can_see_player():
	return player_within_angle(sight_angle) and has_los_player()

func player_within_angle(angle: float):
	var dir_to_player = global_transform.origin.direction_to(player.global_transform.origin)
	var forwards = global_transform.origin
	return rad_to_deg(forwards.angle_to(dir_to_player)) < angle

func has_los_player():
#	var our_pos = global_transform.origin
#	var player_pos = player.global_transform.origin + Vector3.UP
#	var space_state = get_world_3d().get_direct_space_state()
#	var result = space_state.PhysicsRayQueryParameters3D(our_pos, player_pos, [], 1)
#	if result:
#		return false
	return true

func face_direction(dir: Vector2, delta):
	var angle_diff = global_transform.y.angle_to(dir)
	var turn_right = sign(global_transform.x.dot(dir))
	if abs(angle_diff) < deg_to_rad(turn_speed) * delta:
		rotation = atan2(dir.x, dir.y)
	else:
		rotation += rad_to_deg(turn_speed) * delta * turn_right

func within_dis_of_player(dis: float):
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
#	print(distance_to_player)
	return distance_to_player < attack_range

func start_attack():
	can_attack = false
	attack_timer.start()
