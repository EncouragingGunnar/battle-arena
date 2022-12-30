class_name Player
extends KinematicBody2D

const ACCEL = 580
const MAX_SPEED = 100
const FRICTION = 580
const ROLL_SPEED = 230
const ROLL_ACCEL = 480
var roll_time = 0.8

var velocity = Vector2()

var hp = 100

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var stateMachine = $StateMachine
onready var Arrow = preload("res://Scenes/Arrow.tscn")
onready var arrowPosition = $ArrowStartPosition
onready var swordHitbox = $SlashHitboxPosition/Hitbox

func _ready():
	animationTree.active = true
	swordHitbox.set_deferred("monitoring", false)
	swordHitbox.set_deferred("monitorable", false)



