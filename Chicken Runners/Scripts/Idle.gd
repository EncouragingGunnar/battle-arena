extends PlayerState

func enter(_msg := {}):
	player.animationState.travel("Idle")

	
func update(_delta: float):
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		state_machine.transition_to("Run")
	if Input.is_action_just_pressed("MeleeAttack"):
		state_machine.transition_to("Attack1")
	if Input.is_action_just_pressed("RangedAttack"):
		state_machine.transition_to("RangedAttack")
	if Input.is_action_just_pressed("Roll") and player.can_roll:
		state_machine.transition_to("Roll")
	
func physics_update(delta: float):
	player.velocity = player.velocity.move_toward(Vector2.ZERO, player.playerstats.FRICTION * delta)

func handle_input(_event: InputEvent):
	pass

func exit():
	pass

