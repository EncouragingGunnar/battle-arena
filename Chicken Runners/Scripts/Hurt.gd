extends PlayerState

export (float) var knockback_time = 0.3
var current_knockback_time: float =  0
onready var knockbackTween = $"../../KnockbackTween"
onready var hurtAnimationPlayer = $"../../HurtAnimationPlayer"


func enter(_msg := {}):
	current_knockback_time = knockback_time
	knockbackTween.interpolate_property(player, "velocity", player.velocity, player.knockbackImpulse, knockback_time, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	knockbackTween.start()
	hurtAnimationPlayer.play("Hurt")
	#troligen kan inte ha hurtanimationplayer, för den spelar över den andra, hitboxes avaktiveras inte, kill aura
	
	
func update(delta: float) -> void:
	current_knockback_time -= delta
	if current_knockback_time > 0:
		return

	
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.transition_to("Run")
		return
	if Input.is_action_pressed("MeleeAttack"):
		state_machine.transition_to("Attack1")
		return
	if Input.is_action_pressed("RangedAttack"):
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
