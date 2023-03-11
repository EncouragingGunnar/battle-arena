extends Area2D
class_name HurtBox


export (int) var knockback_resistance 
export (float) var invincibility_time
var hit_effect: PackedScene = null

onready var invincibilityTimer = $InvincibilityTimer
onready var collisionShape = $CollisionShape2D


func create_hit_effect(attacker_position: Vector2) -> void:
	if hit_effect != null:
		var hiteffect = hit_effect.instance()
		hiteffect.emitting = true
		hiteffect.rotation = get_angle_to(attacker_position) + PI
		add_child(hiteffect)

func _on_Hurtbox_area_entered(area: Hitbox) -> void:	
	if owner.has_method("take_damage"):
		owner.take_damage(area.damage)
	if owner.has_method("set_knockback_stats"):
		var knockback_direction = (global_position - area.global_position).normalized()
		owner.set_knockback_stats((knockback_direction * area.knockback_strength) / knockback_resistance)
		hit_effect = area.hiteffect
	invincibilityTimer.start(invincibility_time)
	collisionShape.set_deferred("disabled", true)
	create_hit_effect(area.global_position)
	
func _on_InvincibilityTimer_timeout() -> void:
	collisionShape.set_deferred("disabled", false)
	

