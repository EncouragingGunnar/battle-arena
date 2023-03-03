extends PlayerState

export var next_state: String
export var animation_state_name: String
var queued_state: String

func enter(_msg := {}):
	$"../../SlashHitboxPosition/Hitbox2".damage = player.playerstats.melee_damage
	player.animationTree.set("parameters/TimeScale/scale", player.playerstats.melee_attack_speed)
	var attack_vector = player.global_position.direction_to(player.get_global_mouse_position())
	player.animationTree.set("parameters/AnimationNodeStateMachine/Idle/blend_position", attack_vector)
	player.animationTree.set("parameters/AnimationNodeStateMachine/Attack1/blend_position", attack_vector)
	player.animationTree.set("parameters/AnimationNodeStateMachine/Attack2/blend_position", attack_vector)
	player.velocity = Vector2.ZERO
	player.animationState.travel(animation_state_name)
	player.can_input = false
	queued_state = "Idle"

func update(_delta: float):
	pass
	
	
func physics_update(delta: float):
	if player.can_input:
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			if Input.is_action_pressed("Sprint"):
				queued_state = "Run"
			queued_state = "Walk"
		if Input.is_action_just_pressed("ui_right_click"):
			queued_state = "RangedAttack"
		if Input.is_action_just_pressed("Roll"):
			queued_state = "Roll"
		if Input.is_action_just_pressed("Inventory"):
			queued_state = "Inventory"
		if next_state and Input.is_action_pressed("ui_left_click"):
			queued_state = next_state
		
		
func attack_animation_finished() -> void:
	state_machine.transition_to(queued_state)


func handle_input(_event: InputEvent):
	pass
	
func exit():
	player.animationTree.set("parameters/TimeScale/scale", player.playerstats.animation_speed)
	player.swordHitbox2.set_deferred("disabled", true)
	player.can_input = true
