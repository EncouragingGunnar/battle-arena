extends KinematicBody2D

const ACCELERATION = 1000

var max_velocity := 500
var velocity := Vector2.ZERO
var health := 300
var dps := 50
var mouse_pos = Vector2.ZERO
var can_generate_path = true
onready var _agent = $NavigationAgent2D
onready var knight = $Knights

func _ready() -> void:
	global_position = Vector2(300, 300)
	set_process(false)

		
func _process(delta: float) -> void:
	if can_generate_path:
		pass


