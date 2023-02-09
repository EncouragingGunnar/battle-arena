extends PlayerState

var attackPressed = false
export var next_state: String
export var animation_state_name: String

func enter(_msg := {}):
	var attack_vector = player.global_position.direction_to(player.get_global_mouse_position())
	player.animationTree.set("parameters/AnimationNodeStateMachine/Idle/blend_position", attack_vector)
	player.animationTree.set("parameters/AnimationNodeStateMachine/Attack1/blend_position", attack_vector)
	player.animationTree.set("parameters/AnimationNodeStateMachine/Attack2/blend_position", attack_vector)
	player.velocity = Vector2.ZERO
	player.animationState.travel(animation_state_name)
	player.can_input = false

func update(_delta: float):
	pass
	
	
func physics_update(delta: float):
	if next_state and player.can_input and Input.is_action_just_pressed("ui_left_click"):
		state_machine.transition_to(next_state)

	if player.can_input:
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			if Input.is_action_pressed("Sprint"):
				state_machine.transition_to("Run")
			state_machine.transition_to("Walk")
		
func attack_animation_finished() -> void:
	state_machine.transition_to("Idle")

func handle_input(_event: InputEvent):
	pass

func exit():
	player.swordHitbox2.set_deferred("disabled", true)

