extends KinematicBody2D

var hitstun = 0
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var knockbackSpeed = 110
onready var hurtbox = $Hurtbox

func _physics_process(delta):
	move()
	if hitstun > 0:
		hitstun -= 1
	
	elif hitstun == 0 &&  hurtbox.monitoring == false:
		hurtbox.set_deferred("monitoring", true)


func move():
	if hitstun == 0:
		velocity = move_and_slide(velocity)
	else:
		knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	hitstun = 10
	knockback = global_position - area.global_position
	knockback = (knockback.normalized() * knockbackSpeed) 
	hurtbox.set_deferred("monitoring", false)
