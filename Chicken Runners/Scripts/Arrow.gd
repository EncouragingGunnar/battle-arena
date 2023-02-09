extends Node2D

const MOVE_SPEED = 400

onready var hitbox = $Hitbox

var arrow_direction := Vector2.ZERO
var knockback_strength: int
var bow_damage: int

func _ready() -> void:	
	set_as_toplevel(true)
	look_at(position + arrow_direction)
	hitbox.damage = bow_damage
	hitbox.knockback_strength = knockback_strength
	
func _physics_process(delta: float) -> void:
	position += arrow_direction * MOVE_SPEED * delta

func _on_Hitbox_area_entered(area: Area2D) -> void:
	queue_free()


func _on_Hitbox_body_entered(body) -> void:
	if body.is_in_group("WorldObject"):
		queue_free()
