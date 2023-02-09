extends PlayerState

var run_stop_time: float

func enter(msg := {}):
	if msg.has("do_run_stop"):
		player.animationState.travel("RunStop")
		run_stop_time = 0.4
	else:
		player.animationState.travel("Idle")


func update(delta: float):
	if run_stop_time > 0:
		run_stop_time -= delta
		
	if is_equal_approx(run_stop_time, 0):
		player.animationState.travel("Idle")
	
	if player.can_input:	
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			if Input.is_action_pressed("Sprint"):
				state_machine.transition_to("Run")
			state_machine.transition_to("Walk")
		if Input.is_action_just_pressed("ui_left_click"):
			state_machine.transition_to("Attack1")
		if Input.is_action_just_pressed("ui_right_click"):
			state_machine.transition_to("RangedAttack")
		if Input.is_action_just_pressed("Roll") and player.can_roll:
			state_machine.transition_to("Roll")
	
func physics_update(delta: float):
	player.velocity = player.velocity.move_toward(Vector2.ZERO, player.playerstats.FRICTION * delta)

func handle_input(_event: InputEvent):
	pass

func exit():
	pass

