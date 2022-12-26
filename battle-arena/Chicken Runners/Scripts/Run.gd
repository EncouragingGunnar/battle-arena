extends PlayerState


func enter(_msg := {}):
	player.velocity = Vector2.ZERO
	player.animationState.travel("Move")

func physics_update(delta: float):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		player.animationTree.set("parameters/Idle/blend_position", input_vector)
		player.animationTree.set("parameters/Move/blend_position", input_vector)
		player.animationState.travel("Move")
		player.velocity = velocity.move_toward(input_vector * player.MAX_SPEED, player.ACCEL *  delta)
	else:
		animationState.travel("Idle")
		player.velocity = velocity.move_toward(Vector2.ZERO, player.FRICTION * delta)
			
	player.velocity = player.move_and_slide(velocity)

	if is_equal_approx(input_vector.x, 0.0) and is_equal_approx(input_vector.y, 0.0):
		state_machine.transition_to("Idle")

func handle_input(_event: InputEvent):
	pass

func exit():
	pass
