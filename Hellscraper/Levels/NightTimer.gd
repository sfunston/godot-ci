extends Label

@export var night_time_limit = 20

func _ready():
	$Timer.start(night_time_limit)

func _process(delta):
	update_display()
	
	if $Timer.time_left == 0:
		GameManager.set_to_day()
		$Timer.start(999)

func update_display():
	var day_night_text = 'until day: '
	
	text = "\n%s%d:%02d" % [day_night_text, floor($Timer.time_left / 60), int($Timer.time_left) % 60]
