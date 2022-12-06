extends KinematicBody2D

const ACCELERATION = 1000

var max_velocity := 500
var velocity := Vector2.ZERO
var health := 300
var dps := 50
var mouse_pos = Vector2.ZERO
var can_generate_path = true
onready var agent = $NavigationAgent2D


func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	_move_knight(delta)

func _move_knight(delta: float) -> void:
	agent.set_target_location(get_global_mouse_position())
	if Input.is_action_pressed("use"):
		var direction := global_position.direction_to(agent.get_next_location())
		var desired_velocity = direction * max_velocity
		velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
		
	move_and_collide(velocity * delta)
