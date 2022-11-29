extends Sprite

const ACCELERATION = 1000

var max_velocity := 500
var velocity := Vector2.ZERO
var health := 300
var dps := 50
var mouse_pos = Vector2.ZERO
var can_generate_path = true
var path = get_node("MapNavigation").get("new_path")


func _ready() -> void:
	global_position = Vector2(300, 300)
	set_process(false)

		
func _process(delta: float) -> void:
	if can_generate_path:
		pass

func move_along_path(distance : float) -> void:
	var start_point = position
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear.interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			position = path[0]
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)
		
func set_path(value: PoolVector2Array) -> void:
	path = value
	if value.size() == 0:
		return
	set_process(true)
