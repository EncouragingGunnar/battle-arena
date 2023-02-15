extends Node2D

var spear_speed: int = 0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	set_as_toplevel(true)
	rotation += PI/2
	rotation += direction.angle()
	
func _physics_process(delta: float) -> void:
	position += direction * spear_speed * delta

func _on_Hitbox_area_entered(area: Area2D):
	queue_free()

func _on_Hitbox_body_entered(body):
	if body.is_in_group("WorldObject"):
		queue_free()
