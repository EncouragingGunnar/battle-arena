extends KinematicBody2D

var hitstun = 0
var velocity = Vector2.ZERO
var max_hp = 45
var current_hp
var knockback_impulse
var can_update_pathfinding = true
var idle_states = [IDLE, WANDER]
var experience_dropped = 40

const MAX_SPEED = 40
const ACCEL = 150

export (int) var wanderRange = 10
export var path_to_player = NodePath()

onready var player = get_node(path_to_player)
onready var hurtbox = $Hurtbox
onready var sprite = $AnimatedSprite
onready var healthBar = $ProgressBar
onready var healthBarTween = $ProgressBar/Tween
onready var agent = $NavigationAgent2D
onready var pathTimer= $PathTimer
onready var sight = $LineOfSight
onready var wanderTimer = $WanderTimer
onready var tween = $Tween
onready var startPosition = global_position
onready var targetPosition = global_position

enum {
	IDLE,
	WANDER,
	CHASE,
	HURT,
	DEAD
}

var state = IDLE

func _ready():
	current_hp = max_hp
	
func take_damage(damage: int):
	current_hp -= damage
	if current_hp <= 0:
		state = DEAD
	else:
		state = HURT
	if healthBar.visible == false:
		healthBar.visible = true
	var hpPercent = int((float(current_hp) / max_hp) * 100)
	healthBarTween.interpolate_property(healthBar, "value", healthBar.value, hpPercent, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	healthBarTween.start()
	
	
func _drop_coin():
	var coin = preload("res://Scenes/Coin.tscn").instance()
	coin.position = global_position
	get_parent().add_child(coin)
	

func set_knockback_stats(impulse: Vector2):
	knockback_impulse = impulse


func _physics_process(delta: float):
	match state:
		IDLE:
			_idle_state(delta)
		WANDER:
			_wander_state(delta)
		CHASE:
			_chase_state(delta)
		HURT:
			_hurt_state()
		DEAD:
			_dead_state()

	sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)
		


func _on_Hurtbox_area_entered(area: Area2D):
	sprite.material.set_shader_param("hit_opacity", 1)
	hitstun = 10
	
func _idle_state(delta):
	sprite.play("Idle")
	velocity = velocity.move_toward(Vector2.ZERO, ACCEL * delta)
	_look_at_player()
	if _can_see_player():
		state = CHASE	
			
	if wanderTimer.time_left == 0:
		state = idle_states[randi() % idle_states.size()]
		wanderTimer.start(rand_range(1, 3))
	
	
func _wander_state(delta):
	_look_at_player()
	if _can_see_player():
		state = CHASE
	if wanderTimer.time_left == 0:
		state = idle_states[randi() % idle_states.size()]			
		wanderTimer.start(rand_range(1, 3))
		
	_set_velocity(delta)
	sprite.play("Run")

	if agent.is_navigation_finished():
		state = idle_states[randi() % idle_states.size()]
		wanderTimer.start(rand_range(1, 3))

func _chase_state(delta):
	_look_at_player()
	if _can_see_player():
		_update_pathfinding(player.global_position)
		_set_velocity(delta)
		sprite.play("Run")
	else:
		state = IDLE


func _hurt_state():
	if hitstun > 0:
		hitstun -= 1
		knockback_impulse = lerp(knockback_impulse, Vector2.ZERO, 0.1)
		velocity = knockback_impulse
		
	if hitstun == 0:
		sprite.material.set_shader_param("hit_opacity", 0)

func _dead_state() -> void:
	player.gain_experience(experience_dropped)
	call_deferred("_drop_coin")
	queue_free()

func _update_pathfinding(position: Vector2) -> void:
	if is_instance_valid(player) and can_update_pathfinding:
		agent.set_target_location(position)
		can_update_pathfinding = false
		pathTimer.start()
		
func _set_velocity(delta: float):
	var direction = global_position.direction_to(agent.get_next_location())
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCEL *  delta)

func _can_see_player() -> bool:
	var collider = sight.get_collider()
	if collider and collider.is_in_group("Player"):
		return true
	return false
	
func _look_at_player():
	if is_instance_valid(player):
		sight.look_at(player.global_position)
		
	
func _on_PathTimer_timeout():
	can_update_pathfinding = true
	
func _update_target_position():
	targetPosition = startPosition + Vector2(rand_range(-wanderRange, wanderRange), rand_range(-wanderRange, wanderRange))

func _on_WanderTimer_timeout():
	if state != CHASE:
		_update_target_position()
		_update_pathfinding(targetPosition)
