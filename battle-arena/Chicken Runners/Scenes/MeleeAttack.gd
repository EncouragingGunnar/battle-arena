extends PlayerState

func enter(_msg := {}):
	player.velocity = Vector2.ZERO
	animationState.travel("MeleeAttack")
	player.swordHitbox.set_deferred("monitoring", true)
	player.swordHitbox.set_deferred("monitorable", true)

func update(_delta: float):
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		state_machine.transition_to("Run")

func attack_animation_finished():
	state_machine.transition_to("Idle")
	
func physics_update(delta: float):
	pass

func handle_input(_event: InputEvent):
	pass

func exit():
	player.swordHitbox.set_deferred("monitoring", false)
	player.swordHitbox.set_deferred("monitorable", false)
