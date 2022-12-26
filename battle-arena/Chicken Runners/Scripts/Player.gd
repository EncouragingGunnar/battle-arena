class_name Player
extends KinematicBody2D

const ACCEL = 400
const MAX_SPEED = 130
const FRICTION = 600

export var velocity = Vector2.ZERO


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var stateMachine = $StateMachine



