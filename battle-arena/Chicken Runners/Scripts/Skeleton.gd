extends KinematicBody2D

var hitstun = 0
var velocity = Vector2.ZERO
var knockbackDirection = Vector2.ZERO
var knockbackStrength 
var knockbackResistance = 1
var max_hp = 45
var current_hp
onready var hurtbox = $Hurtbox
onready var sprite = $AnimatedSprite
onready var healthBar = $ProgressBar
onready var healthBarTween = $ProgressBar/Tween

func _ready():
	current_hp = max_hp

	
func take_damage(damage):
	current_hp -= damage
	var hpPercent = int((float(current_hp) / max_hp) * 100)
	healthBarTween.interpolate_property(healthBar, "value", healthBar.value, hpPercent, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	healthBarTween.start()
	if current_hp <= 0:
		die()
		
func die():
	queue_free()

func set_knockback_stats(strength):
	knockbackStrength = strength

func _physics_process(delta):
	move()
	if hitstun > 0:
		hitstun -= 1
	
	elif hitstun == 0 and hurtbox.monitoring == false:
		hurtbox.set_deferred("monitoring", true)

func move():
	if hitstun == 0:
		sprite.material.set_shader_param("hit_opacity", 0)
		velocity = move_and_slide(velocity)
	else:
		var knockback_impulse = (knockbackDirection * knockbackStrength) / knockbackResistance
		move_and_slide(knockback_impulse)

func _on_Hurtbox_area_entered(area):
	sprite.material.set_shader_param("hit_opacity", 1)
	hitstun = 10
	knockbackDirection = (global_position - area.global_position).normalized()
	hurtbox.set_deferred("monitoring", false)
