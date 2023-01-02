extends Area2D


export (int) var knockbackResistance 
export (float) var invincibilityTime

onready var invincibilityTimer = $InvincibilityTimer
onready var collisionShape = $CollisionShape2D


func _on_Hurtbox_area_entered(area) -> void:	
	if owner.has_method("take_damage"):
		owner.take_damage(area.damage)
	if owner.has_method("set_knockback_stats"):
		var knockbackDirection = (global_position - area.global_position).normalized()
		owner.set_knockback_stats((knockbackDirection * area.knockbackStrength) / knockbackResistance)
	invincibilityTimer.start(invincibilityTime)
	collisionShape.set_deferred("disabled", true)
	
func _on_InvincibilityTimer_timeout():
	collisionShape.set_deferred("disabled", false)
	

