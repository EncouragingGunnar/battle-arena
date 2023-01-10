extends Node2D

const MOVE_SPEED = 400

onready var hitbox = $Hitbox

var arrow_direction := Vector2.ZERO
var knockback_strength 
var bow_damage 

func _ready():
	set_as_toplevel(true)
	look_at(position + arrow_direction)
	hitbox.damage = bow_damage
	hitbox.knockbackStrength = knockback_strength
	
func _physics_process(delta):
	position += arrow_direction * MOVE_SPEED * delta

func _on_Hitbox_area_entered(area):
	queue_free()


func _on_Hitbox_body_entered(body):
	if body.is_in_group("WorldObject"):
		queue_free()
