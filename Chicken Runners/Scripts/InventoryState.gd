extends PlayerState



func enter(msg := {}):
	player.in_inventory = !player.in_inventory
	player.Inventorycontainer.visible = !player.Inventorycontainer.visible
	player.animationState.travel("Idle")

func update(delta: float):
	if Input.is_action_just_pressed("Inventory"):
		state_machine.transition_to("Idle")
	
func physics_update(delta: float):
	player.velocity = player.velocity.move_toward(Vector2.ZERO, player.playerstats.FRICTION * delta)

func handle_input(_event: InputEvent):
	pass

func exit():
	player.Inventorycontainer.visible = !player.Inventorycontainer.visible
	if player.Inventorycontainer.has_node("DragPreview"):
		var empty_drag_preview = Control.new()
		player.Inventorycontainer.set_drag_preview(empty_drag_preview)
