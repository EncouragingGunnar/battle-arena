extends PlayerState

func enter(_msg := {}):
	player.animationState.travel("Run")


func physics_update(delta: float):
	"""
	tar in en input vector med get action strength
	gör om den till en vektor med längden 1
	sätter animationtree blend position till denna vektor
	sätter velocity med hjälp av move toward
	rör sig med move and slite
	kontrollerar om velocity är 0 i båda led, byt då till idle och gör ett run stop
	"""
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		player.animationTree.set("parameters/AnimationNodeStateMachine/Idle/blend_position", input_vector)
		player.animationTree.set("parameters/AnimationNodeStateMachine/Run/blend_position", input_vector)
		player.animationTree.set("parameters/AnimationNodeStateMachine/Roll/blend_position", input_vector)
		player.animationTree.set("parameters/AnimationNodeStateMachine/RunStop/blend_position", input_vector)
		player.velocity = player.velocity.move_toward(input_vector * player.playerstats.RUN_MAX_SPEED, player.playerstats.ACCEL *  delta)
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, player.playerstats.FRICTION * delta)

		
	player.velocity = player.move_and_slide(player.velocity)
	if is_equal_approx(player.velocity.x, 0.0) and is_equal_approx(player.velocity.y, 0.0):
		state_machine.transition_to("Idle", {do_run_stop = true})
		

		

func handle_input(_event: InputEvent):
	"""
	hanterar nödvändiga inputs
	"""
	if Input.is_action_just_released("Sprint"):
		state_machine.transition_to("Walk")
	if Input.is_action_just_pressed("ui_left_click"):
		state_machine.transition_to("Attack1")
	if Input.is_action_just_pressed("ui_right_click"):
		state_machine.transition_to("RangedAttack")
	if Input.is_action_just_pressed("Roll") and player.can_roll:
		state_machine.transition_to("Roll")
	if Input.is_action_just_pressed("Inventory"):
		state_machine.transition_to("Inventory")
	

func exit():
	pass
	
