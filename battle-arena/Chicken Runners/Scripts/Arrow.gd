extends Node2D

const MOVE_SPEED = 400

var arrow_direction := Vector2.ZERO
var knockback_strength 
var bow_damage 

func _ready():
	set_as_toplevel(true)
	look_at(position + arrow_direction)
	
func _physics_process(delta):
	position += arrow_direction * MOVE_SPEED * delta


func _on_Hitbox_body_entered(body):
	if body.has_method("set_knockback_stats"):
		body.set_knockback_stats(knockback_strength)
	if body.is_in_group("Enemy"):
		body.take_damage(bow_damage)
	queue_free()
