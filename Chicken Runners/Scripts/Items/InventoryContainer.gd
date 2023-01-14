extends TextureRect

func _input(event):
	if event.is_action_pressed("Inventory"):
		if visible:
			visible = false
		else:
			visible = true


			
