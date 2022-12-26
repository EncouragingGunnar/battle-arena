class_name PlayerState
extends State

onready var player : Player
onready var velocity = Vector2.ZERO
onready var animationTree
onready var animationState

const ACCEL = 400
const MAX_SPEED = 130
const FRICTION = 600

func _ready():
	yield(owner, "ready")
	player = owner as Player
	assert(player != null)
	
	animationTree = player.get_node("AnimationTree")
	animationState = animationTree.get("parameters/playback")

	
func update(_delta: float):
	pass
	
func _physics_process(_delta: float):
	pass

func _unhandled_input(_event: InputEvent):
	pass

func enter(_msg := {}):
	pass

func exit():
	pass
