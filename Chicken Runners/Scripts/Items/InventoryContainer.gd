extends TextureRect

func _unhandled_input(event):
	if event.is_action_pressed("Inventory"):
		visible = !visible


