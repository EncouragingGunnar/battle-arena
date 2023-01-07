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
		player.animationTree.set("parameters/Attack1/blend_position", input_vector)
		player.animationTree.set("parameters/Attack2/blend_position", input_vector)
		player.animationTree.set("parameters/Attack3/blend_position", input_vector)
		player.animationTree.set("parameters/Roll/blend_position", input_vector)
		player.animationTree.set("parameters/RangedAttack/blend_position", input_vector)
		player.animationState.travel("Move")
		player.velocity = player.velocity.move_toward(input_vector * player.MAX_SPEED, player.ACCEL *  delta)
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, player.FRICTION * delta)

		
	player.velocity = player.move_and_slide(player.velocity)

	if is_equal_approx(player.velocity.x, 0.0) and is_equal_approx(player.velocity.y, 0.0):
		state_machine.transition_to("Idle")
	
		

func handle_input(_event: InputEvent):
	if Input.is_action_just_pressed("MeleeAttack"):
		state_machine.transition_to("Attack1")
	if Input.is_action_just_pressed("RangedAttack"):
		state_machine.transition_to("RangedAttack")
	if Input.is_action_just_pressed("Roll") and player.can_roll:
		state_machine.transition_to("Roll")
	
	
func exit():
	pass
