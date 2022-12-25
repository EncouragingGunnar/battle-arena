extends KinematicBody2D

var velocity := Vector2.ZERO
var health := 300
var dps := 50
var mouse_pos = Vector2.ZERO
onready var agent = $NavigationAgent2D
var has_arrived = true


func _ready() -> void:
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		has_arrived = false			
		var target_location = get_global_mouse_position()
		agent.set_target_location(target_location)
	
	
func _physics_process(delta: float) -> void:
	var move_direction = position.direction_to(agent.get_next_location())
	velocity = move_direction * agent.max_speed
	agent.set_velocity(velocity)
	
	if not has_arrived:
		move_and_slide(velocity)
	if agent.is_navigation_finished():
		has_arrived = true

	
