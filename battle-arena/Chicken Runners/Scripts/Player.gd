class_name Player
extends KinematicBody2D

export var ACCEL = 580
export var MAX_SPEED = 100
export var FRICTION = 580
export var ROLL_SPEED = 230
export var ROLL_ACCEL = 480
var roll_time = 0.8
var knockback_strength = 100
var melee_damage = 15
var bow_damage = 10


var velocity = Vector2()

var hp = 100

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var stateMachine = $StateMachine
onready var Arrow = preload("res://Scenes/Arrow.tscn")
onready var arrowPosition = $ArrowStartPosition
onready var swordHitbox = $SlashHitboxPosition/Hitbox

var can_roll = true

func _ready():
	animationTree.active = true
	swordHitbox.set_deferred("monitoring", false)
	swordHitbox.set_deferred("monitorable", false)

func _on_RollTimer_timeout():
	can_roll = true
