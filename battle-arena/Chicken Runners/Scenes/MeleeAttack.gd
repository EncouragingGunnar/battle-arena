extends PlayerState

func enter(_msg := {}):
	player.velocity = Vector2.ZERO
	animationState.travel("MeleeAttack")
	

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
	pass


func _on_Hitbox_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(player.melee_damage)
	body.set_knockback_stats(player.knockback_strength)
