class_name Player
extends KinematicBody2D

export var ACCEL = 580
export var MAX_SPEED = 100
export var FRICTION = 580
export var ROLL_SPEED = 230
export var ROLL_ACCEL = 480
var roll_time = 0.8
var player_knockback_strength = 150
var playerKnockbackResistance = 3
var melee_damage = 15
var bow_damage = 10
var hitstun = 0

var velocity = Vector2()
var knockbackImpulse = Vector2()

var max_hp = 100
var current_hp

onready var animationPlayer = $AnimationPlayer2
onready var animationTree = $AnimationTree2
onready var animationState = animationTree.get("parameters/playback")
onready var stateMachine = $StateMachine
onready var Arrow = preload("res://Scenes/Arrow.tscn")
onready var arrowPosition = $ArrowStartPosition
onready var swordHitbox = $SlashHitboxPosition/Hitbox/CollisionShape2D
onready var collisionShape = $CollisionShape2D
onready var hurtbox = $Hurtbox
onready var sprite = $Sprite2

var can_roll = true

func _ready():
	randomize()
	animationTree.active = true
	swordHitbox.set_deferred("disabled", true)
	current_hp = max_hp

func _on_RollTimer_timeout():
	can_roll = true

func take_damage(damage):
	current_hp -= damage
	print(current_hp)
	if current_hp <= 0:
		die()
		
func die():
	queue_free()
	
func set_knockback_stats(impulse):
	knockbackImpulse = impulse
	
	
func _physics_process(delta):
	if hitstun > 0:
		hitstun -= 1
		knockbackImpulse = lerp(knockbackImpulse, Vector2.ZERO, 0.1)
		velocity = move_and_slide(knockbackImpulse)
	
	if hitstun == 0:
		sprite.material.set_shader_param("hit_opacity", 0)
		

func _on_Hurtbox_area_entered(area):
	sprite.material.set_shader_param("hit_opacity", 1)
	hitstun = 10

