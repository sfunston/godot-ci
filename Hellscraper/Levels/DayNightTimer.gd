extends Label

@export var day_time_limit = 20


func _ready():
	$Timer.start(day_time_limit)

func _process(delta):
	update_display()
	
	if $Timer.time_left == 0:
		GameManager.set_to_night()
		$Timer.start(999)

func update_display():
	var day_night_text = 'until night: '
	
	text = "\n%s%d:%02d" % [day_night_text, floor($Timer.time_left / 60), int($Timer.time_left) % 60]
