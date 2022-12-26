extends PlayerState

func enter(_msg := {}):
	player.velocity = Vector2.ZERO

	
func update(_delta: float):
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		state_machine.transition_to("Run")
	
func physics_update(_delta: float):
	pass

func handle_input(_event: InputEvent):
	pass

func exit():
	pass

