extends PlayerState

export (float) var knockback_time = 0.3
var current_knockback_time: float =  0
onready var knockbackTween = $"../../KnockbackTween"


func enter(msg := {}):
	"""
	ställer in nödvändiga variabler
	"""
	assert(msg.has("knockback_stats"))
	if player.in_inventory:
		player.in_inventory = !player.in_inventory
		player.Inventorycontainer.visible = false
	current_knockback_time = knockback_time
	knockbackTween.interpolate_property(player, "velocity", player.velocity, msg["knockback_stats"], knockback_time, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	knockbackTween.start()
	knockbackTween.interpolate_method(player, "change_hit_opacity", 0, 1, 0.2, Tween.TRANS_LINEAR)
	knockbackTween.interpolate_method(player, "change_hit_opacity", 1, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)

	
func update(delta: float) -> void:
	"""
	hårdvarutimer som kollar om knockback time är slut och sedan kan man trycka på tangenter
	"""
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
	if Input.is_action_just_pressed("Inventory"):
		state_machine.transition_to("Inventory")
		return
	else:
		state_machine.transition_to("Idle")
		return
	
	

func physics_update(_delta):
	player.velocity = player.move_and_slide(player.velocity)
	
func handle_input(_event: InputEvent):
	pass

func exit():
	pass
