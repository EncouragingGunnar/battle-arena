extends TextureRect

func _input(event):
	if event.is_action_pressed("Inventory"):
		visible = !visible


