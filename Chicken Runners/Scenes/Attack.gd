extends PlayerState

var attackPressed = false
export var next_state: String
export var animation_state_name: String

func enter(_msg := {}):
	player.velocity = Vector2.ZERO
	player.animationState.travel(animation_state_name)
	player.canInput = false
	

func update(_delta: float):
	pass
	
func physics_update(delta: float):
		
	if next_state and player.canInput and Input.is_action_just_pressed("MeleeAttack"):
		state_machine.transition_to(next_state)
		
	if player.canInput:
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			state_machine.transition_to("Run")
		
func attack_animation_finished():
	state_machine.transition_to("Idle")

func handle_input(_event: InputEvent):
	pass

func exit():
	pass

