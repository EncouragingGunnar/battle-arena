extends Control


func _unhandled_input(event: InputEvent) -> void:
	"""
	om esc trycks ned byt till pausad om vi inte är det och v.v
	"""
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			show()
		else:
			hide()

			

func _on_Button_pressed() -> void:
	"""
	gör så man kan fortsätta
	"""
	get_tree().paused = !get_tree().paused
	hide()


func _on_QuitButton_pressed():
	"""
	avslutar spelet
	"""
	get_tree().quit()
