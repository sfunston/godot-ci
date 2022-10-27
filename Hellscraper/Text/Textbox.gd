extends CanvasLayer

var CHAR_READ_RATE = 0.0666

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label
@onready var tween

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_textbox()
	
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("pickup"):
				label.visible_ratio = 1.0
				tween.stop()
				on_text_end()
			
			if !tween.is_running():
				on_text_end()
				
		State.FINISHED:
			end_symbol.text = "Space"
			if Input.is_action_just_pressed("pickup"):
				change_state(State.READY)
				hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)
	
func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()
	
func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.visible_ratio = 0.0
	change_state(State.READING)
	show_textbox()
	tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE)
	tween.set_ease(tween.EASE_IN_OUT)
	tween.set_trans(tween.TRANS_LINEAR)
	tween.play()
	
func change_state(next_state):
	current_state = next_state
#	match current_state:
#		State.READY:
#			print("Changing state to: State.READY")
#		State.READING:
#			print("Changing state to: State.READING")
#		State.FINISHED:
#			print("Changing state to: State.FINISHED")

func on_text_end():
	change_state(State.FINISHED)

func play_text():
	current_state = State.READY
