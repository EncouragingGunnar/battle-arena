extends PlayerState

func enter(_msg := {}):
	player.velocity = Vector2.ZERO
	animationState.travel("RangedAttack")

func update(_delta: float):
	pass

func attack_animation_finished():
	state_machine.transition_to("Idle")
	
func physics_update(delta: float):
	pass

func handle_input(_event: InputEvent):
	pass

func exit():
	pass

