extends CharacterBody2D

@onready var one_time_text = false
@onready var riddles : Dictionary = {
"Chest": "I am buried underground, and above me is a red letter.",
"Stove": "What sizzles sauces, and bakes lasagnas?" ,
"PottedPlant": "Give it water, light, and a ceramic home. In return you receive air, the purest for your biome." ,
"Candlabra": "My time grows short as my tip enrages, but it only takes a breeze to stop me from aging." ,
"Painting": "What do you call colors in a box, organized by an animal who wears sox?" ,
"Vase": "Be careful not bump or tip, if it breaks, your Mother will flip." ,
"Rock": "Put me on the end of a bed, and I become the crust of Earth. Put me at the beginning of a slide, and I'm a rolling disaster." ,
"Logs": "What grows grains, and builds barns?" ,
"Umbrella": "When you need me I open up for you. You hold me above and I protect you." ,
"Cat": "I have many lives to spare. Sometimes I'm friendly, and other times I don't care." ,
"Shovel": "You can use me to bury bodies and plant seeds. I'm a tool used for many deeds." ,
"MirrorRound": "If you drop me I will surely crack. When you smile at me, I'll smile back." ,
"Amulet": "This is a piece of jewelry. It isn't a ring or earring. It also isn't a bracelet. Usually made of chain that holds a pendant or locket." ,
"Ladder": "These are like stairs that are portable." ,
}

var todays_riddle


func _ready():
	if GameManager.wanted_items == null:
		var offerings = get_tree().get_nodes_in_group("Offering")
		
		var random_indexes = []
		while len(random_indexes) < 5:
			var rand_i = randi_range(0, len(offerings) - 1)
			if rand_i not in random_indexes:
				random_indexes.append(rand_i)
		
		var goats_wanted_item_names = []
		for i in random_indexes:
			goats_wanted_item_names.append(offerings[i].name)
		
		GameManager.wanted_items = goats_wanted_item_names
	
	var wants = GameManager.wanted_items
	var haves_objs = GameManager.item_array
	
	var haves = []
	for haves_obj in haves_objs:
		if haves_obj:
			haves.append(haves_obj.name)
	
	var needed_item 
	for want in wants:
		if want not in haves:
			needed_item = want
	
	if needed_item != null:
		todays_riddle = riddles[needed_item]


func _input(event):
	var bodies = $Area2d.get_overlapping_bodies()
	var player_nearby = false
	for body in bodies:
		if body.name == "Player":
			player_nearby = true
	
	if event.is_action_pressed("pickup") and player_nearby:
		find_and_use_dialogue()
		$QuestionMark.hide()
		$Spacebar.hide()

func find_and_use_dialogue():
	var textbox = get_node_or_null("Textbox")
	
	if !one_time_text and todays_riddle:
		textbox.queue_text("This magic circle will aid you. Find the correct objects to empower within it.")
		textbox.queue_text(todays_riddle)
	
		one_time_text = true
