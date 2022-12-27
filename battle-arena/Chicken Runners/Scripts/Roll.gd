extends PlayerState

export (float) var roll_time = 0.8
var current_roll_time: float =  0
var roll_direction = Vector2.ZERO

func enter(_msg := {}):
	animationState.travel("Roll")
	current_roll_time = roll_time
	roll_direction = animationTree.get("parameters/Roll/blend_position")
	player.velocity = Vector2.ZERO
	
func update(delta: float) -> void:
	current_roll_time -= delta
	if current_roll_time > 0:
		return
	
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.transition_to("Run")
	elif Input.is_action_just_pressed("MeleeAttack"):
		state_machine.transition_to("MeleeAttack")
	elif Input.is_action_just_pressed("RangedAttack"):
		state_machine.transition_to("RangedAttack")
	else:
		state_machine.transition_to("Idle")

	
func physics_update(delta: float):
	player.velocity = roll_direction * player.ROLL_SPEED
	player.velocity = player.move_and_slide(player.velocity)
	
func handle_input(_event: InputEvent):
	pass

func exit():
	pass
