extends PlayerState


func enter(_msg := {}):
	player.velocity = Vector2.ZERO
	var attack_vector = player.global_position.direction_to(player.get_global_mouse_position())
	player.animationTree.set("parameters/AnimationNodeStateMachine/Idle/blend_position", attack_vector)
	player.animationTree.set("parameters/AnimationNodeStateMachine/RangedAttack/blend_position", attack_vector)
	player.animationState.travel("RangedAttack")
	

func update(_delta: float):
	pass

func attack_animation_finished():
	state_machine.transition_to("Idle")
	
func shoot_arrow():
	var arrow = player.Arrow.instance()
	arrow.knockback_strength = player.playerstats.player_knockback_strength
	arrow.bow_damage = player.playerstats.bow_damage
	arrow.position = player.arrowPosition.global_position
	arrow.arrow_direction = player.animationTree.get("parameters/AnimationNodeStateMachine/RangedAttack/blend_position")
	player.add_child(arrow)


func physics_update(delta: float):
	pass

func handle_input(_event: InputEvent):
	pass

func exit():
	pass

