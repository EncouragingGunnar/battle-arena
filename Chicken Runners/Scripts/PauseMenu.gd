extends Control


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			show()
		else:
			hide()

			
			

func _on_Button_pressed():
	get_tree().paused = !get_tree().paused
	hide()


func _on_QuitButton_pressed():
	get_tree().quit()
