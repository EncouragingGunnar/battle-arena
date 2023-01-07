extends PlayerState

export (float) var roll_time = 0.8
var current_roll_time: float =  0
onready var rollTimer = $RollTimer
var roll_direction = Vector2()

func enter(_msg := {}):
	player.animationState.travel("Roll")
	current_roll_time = roll_time
	roll_direction = player.animationTree.get("parameters/Roll/blend_position")
	player.velocity = Vector2.ZERO
	player.can_roll = false
	
func update(delta: float) -> void:
	current_roll_time -= delta
	if current_roll_time > 0:
		return
	
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.transition_to("Run")
		return
	if Input.is_action_pressed("MeleeAttack"):
		state_machine.transition_to("Attack1")
		return
	if Input.is_action_pressed("RangedAttack"):
		state_machine.transition_to("RangedAttack")
		return
	else:
		state_machine.transition_to("Idle")
		return
	

func physics_update(delta: float):
	player.velocity = player.velocity.move_toward(player.ROLL_SPEED * roll_direction, player.ROLL_ACCEL *  delta)
	player.velocity = player.move_and_slide(player.velocity)
	
func handle_input(_event: InputEvent):
	pass

func exit():
	rollTimer.start()
	player.can_roll = false
