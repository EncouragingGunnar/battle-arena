extends Area2D


export (int) var knockback_resistance 
export (float) var invincibility_time
var hitEffect: PackedScene = null

onready var invincibilityTimer = $InvincibilityTimer
onready var collisionShape = $CollisionShape2D


func create_hit_effect(attacker_position: Vector2):
	if hitEffect != null:
		var hiteffect = hitEffect.instance()
		hiteffect.emitting = true
		hiteffect.rotation = get_angle_to(attacker_position) + PI
		add_child(hiteffect)

func _on_Hurtbox_area_entered(area) -> void:	
	if owner.has_method("take_damage"):
		owner.take_damage(area.damage)
	if owner.has_method("set_knockback_stats"):
		var knockback_direction = (global_position - area.global_position).normalized()
		owner.set_knockback_stats((knockback_direction * area.knockback_strength) / knockback_resistance)
		hitEffect = area.hiteffect
	invincibilityTimer.start(invincibility_time)
	collisionShape.set_deferred("disabled", true)
	create_hit_effect(area.global_position)
	
func _on_InvincibilityTimer_timeout():
	collisionShape.set_deferred("disabled", false)
	

