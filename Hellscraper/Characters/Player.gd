extends CharacterBody2D


@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

# parameters/Idle/blend_position
@onready var item_position = $Position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var health_manager = $HealthManager

var canPick = true
var item_array : Array = [null, null, null, null, null]
var _penta_item_positions: Array = [null, null, null, null, null]

func _ready():
	if GameManager.is_combat_time():
		var item_index = 0
		for item in GameManager.item_array:
			if item:
				var new_item = item.duplicate()
				add_child(new_item)
				
				new_item.get_node("CollisionShape2d").disabled = true
				new_item.get_node("Sprite2d").visible = false
				
				new_item.active = true
				
				item_array[item_index] = new_item
			else:
				item_array[item_index] = null
			item_index += 1
		
		GameManager.item_array = item_array
	
	update_animation_parameters(starting_direction)
	
	health_manager.dead_signal.connect(self.set_state_dead)


func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left")
		,Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	update_animation_parameters(input_direction)
	
	velocity = input_direction * move_speed
	
	if input_direction != Vector2(0,0):
		item_position.position = input_direction * 20
	
	if velocity != Vector2(0, 0):
		$GpuParticles2d.show()
	else:
		$GpuParticles2d.hide()
	
	move_and_slide()
	
	if GameManager.is_combat_time():
		for item in item_array:
			if item:
				item.position = position

func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func set_state_dead():
	GameManager.reset_globals()
	get_tree().change_scene_to_file("res://Menu/game_over.tscn")
