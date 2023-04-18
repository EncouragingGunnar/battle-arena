extends PlayerState

export (float) var roll_time = 0.8
var current_roll_time: float =  0
onready var rollTimer = $RollTimer
onready var rollTween = $"../../RollTween"
var roll_direction = Vector2()


func enter(_msg := {}):
	"""
	ställer in nödvändiga variabler
	"""
	player.animationState.travel("Roll")
	current_roll_time = roll_time
	roll_direction = player.animationTree.get("parameters/AnimationNodeStateMachine/Roll/blend_position")
	rollTween.interpolate_property(player, "velocity", Vector2.ZERO, roll_direction * player.playerstats.ROLL_SPEED, roll_time, Tween.TRANS_EXPO, Tween.EASE_OUT)
	rollTween.start()
	player.can_roll = false
	player.hurtbox.monitorable = false
	player.hurtbox.monitoring = false
	
func update(delta: float) -> void:
	"""
	kontrollerar om roll time är slut om den är det kan man byta state
	"""
	current_roll_time -= delta
	if current_roll_time > 0:
		return
	
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("Sprint"):
			state_machine.transition_to("Run")
			return
		state_machine.transition_to("Walk")
		return
		
	if Input.is_action_pressed("ui_left_click"):
		state_machine.transition_to("Attack1")
		return
	if Input.is_action_pressed("ui_right_click"):
		state_machine.transition_to("RangedAttack")
		return
	else:
		state_machine.transition_to("Idle")
		return
	if Input.is_action_just_pressed("Inventory"):
		state_machine.transition_to("Inventory")
		return
	

func physics_update(delta: float):
	player.velocity = player.move_and_slide(player.velocity)
	
func handle_input(_event: InputEvent):
	pass

func exit():
	rollTimer.start()
	player.can_roll = false
	player.hurtbox.monitorable = true
	player.hurtbox.monitoring = true
