extends PlayerState

export (float) var knockback_time = 0.3
var current_knockback_time: float =  0
onready var knockbackTween = $"../../KnockbackTween"


func enter(msg := {}):
	assert(msg.has("knockback_stats"))
	current_knockback_time = knockback_time
	knockbackTween.interpolate_property(player, "velocity", player.velocity, msg["knockback_stats"], knockback_time, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	knockbackTween.start()
	knockbackTween.interpolate_method(player, "change_hit_opacity", 0, 1, 0.2, Tween.TRANS_LINEAR)
	knockbackTween.interpolate_method(player, "change_hit_opacity", 1, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)

	
func update(delta: float) -> void:
	current_knockback_time -= delta
	if current_knockback_time > 0:
		return

	
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("Sprint"):
			state_machine.transition_to("Run")
			return
		state_machine.transition_to("Walk")
		return
		
	if Input.is_action_pressed("ui_left_click"):
		state_machine.transition_to("Attack1")
		return
	if Input.is_action_pressed("ui_right_click"):
		state_machine.transition_to("RangedAttack")
		return
	else:
		state_machine.transition_to("Idle")
		return
	

func physics_update(delta: float):
	player.velocity = player.move_and_slide(player.velocity)
	
func handle_input(_event: InputEvent):
	pass

func exit():
	pass
