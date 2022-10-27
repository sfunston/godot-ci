extends CanvasLayer

signal faded_to_black

func transition():
	$AnimationPlayer.play("fade_to_black")
	$BlackScreen.visible = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		emit_signal("faded_to_black")
		$AnimationPlayer.play("fade_to_normal")
