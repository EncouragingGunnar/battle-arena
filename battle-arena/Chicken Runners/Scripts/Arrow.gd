extends Node2D

const MOVE_SPEED = 400

var arrow_direction := Vector2.ZERO

func _ready():
	set_as_toplevel(true)
	look_at(position + arrow_direction)
	
func _physics_process(delta):
	position += arrow_direction * MOVE_SPEED * delta


func _on_Hitbox_body_entered(body):
	queue_free()
