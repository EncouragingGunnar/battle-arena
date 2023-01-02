extends PlayerState


func enter(_msg := {}):
	player.velocity = Vector2.ZERO
	animationState.travel("RangedAttack")


func update(_delta: float):
	pass

func attack_animation_finished():
	state_machine.transition_to("Idle")
	
func shoot_arrow():
	var arrow = player.Arrow.instance()
	arrow.knockback_strength = player.player_knockback_strength
	arrow.bow_damage = player.bow_damage
	arrow.position = player.arrowPosition.global_position
	arrow.arrow_direction = animationTree.get("parameters/RangedAttack/blend_position")
	player.add_child(arrow)


func physics_update(delta: float):
	pass

func handle_input(_event: InputEvent):
	pass

func exit():
	pass

