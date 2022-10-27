extends Control


func _ready():
	pass
#	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Levels/SceneManager.tscn")

func _on_option_button_pressed():
	var option = load("res://Menu/optionsmenu.tscn").instantiate()
	get_tree().current_scene.add_child(option)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Menu/mainMenu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
