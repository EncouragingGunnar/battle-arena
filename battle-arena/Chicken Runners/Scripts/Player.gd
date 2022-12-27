class_name Player
extends KinematicBody2D

const ACCEL = 1000
const MAX_SPEED = 100
const FRICTION = 1200
const ROLL_SPEED = 130
var roll_time = 0.8

export var velocity = Vector2.ZERO

var hp = 100

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var stateMachine = $StateMachine

func _ready():
	animationTree.active = true


