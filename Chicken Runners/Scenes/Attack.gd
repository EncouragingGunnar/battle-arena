extends PlayerState

var attackPressed = false
export var next_state: String
export var animation_state_name: String

func enter(_msg := {}):
	var attack_vector = player.global_position.direction_to(player.get_global_mouse_position())
	player.animationTree.set("parameters/Idle/blend_position", attack_vector)
	player.animationTree.set("parameters/Attack1/blend_position", attack_vector)
	player.animationTree.set("parameters/Attack2/blend_position", attack_vector)
	player.animationTree.set("parameters/Attack3/blend_position", attack_vector)
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

