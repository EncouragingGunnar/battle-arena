extends Node2D

var spear_speed = 0
var direction := Vector2.ZERO

func _ready():
	set_as_toplevel(true)
	rotation += direction.angle()
	
func _physics_process(delta):
	position += direction * spear_speed * delta

func _on_Hitbox_area_entered(area):
	queue_free()

func _on_Hitbox_body_entered(body):
	if body.is_in_group("WorldObject"):
		queue_free()
