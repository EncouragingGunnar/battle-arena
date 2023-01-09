extends KinematicBody2D

var hitstun = 0
var velocity = Vector2.ZERO
var max_hp = 45
var current_hp
var knockbackImpulse
var can_update_pathfinding = true
var idle_states = [IDLE, WANDER]
var experience_dropped = 40

const MAX_SPEED = 60
const ACCEL = 200

export (int) var wanderRange = 10
export var path_to_player = NodePath()

onready var player = get_node(path_to_player)
onready var hurtbox = $Hurtbox
onready var sprite = $AnimatedSprite
onready var healthBar = $ProgressBar
onready var healthBarTween = $ProgressBar/Tween
onready var agent = $NavigationAgent2D
onready var pathTimer: Timer = $PathTimer
onready var sight = $LineOfSight
onready var wanderTimer = $WanderTimer
onready var tween = $Tween
onready var startPosition = global_position
onready var targetPosition = global_position

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _ready():
	current_hp = max_hp
	
func take_damage(damage):
	if healthBar.visible == false:
		healthBar.visible = true
	current_hp -= damage
	var hpPercent = int((float(current_hp) / max_hp) * 100)
	healthBarTween.interpolate_property(healthBar, "value", healthBar.value, hpPercent, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	healthBarTween.start()
	if current_hp <= 0:
		die()
		
func drop_coin():
	var coin = preload("res://Scenes/Coin.tscn").instance()
	coin.position = global_position
	get_parent().add_child(coin)


func die():
	player.gain_experience(experience_dropped)
	call_deferred("drop_coin")
	queue_free()

func set_knockback_stats(impulse):
	knockbackImpulse = impulse


func _physics_process(delta):
	if hitstun > 0:
		hitstun -= 1
		knockbackImpulse = lerp(knockbackImpulse, Vector2.ZERO, 0.1)
		velocity = move_and_slide(knockbackImpulse)
		
	if hitstun == 0:
		sprite.material.set_shader_param("hit_opacity", 0)

	
	match state:
		IDLE:
			sprite.play("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, ACCEL * delta)
			if is_instance_valid(player):
				sight.look_at(player.global_position)
				if can_see_player():
					state = CHASE	
			
			
			if wanderTimer.time_left == 0:
				state = idle_states[randi() % idle_states.size()]
				wanderTimer.start(rand_range(1, 3))
				
		WANDER:
			if is_instance_valid(player):
				sight.look_at(player.global_position)
				if can_see_player():
					state = CHASE
			if wanderTimer.time_left == 0:
				state = idle_states[randi() % idle_states.size()]			
				wanderTimer.start(rand_range(1, 3))
				
			var direction = global_position.direction_to(agent.get_next_location())
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCEL *  delta)
			sprite.play("Run")
			
			if agent.is_navigation_finished():
				state = idle_states[randi() % idle_states.size()]
				wanderTimer.start(rand_range(1, 3))
		CHASE:
			if is_instance_valid(player):
				sight.look_at(player.global_position)
				if can_see_player():
					update_pathfinding(player.global_position)
					var direction = global_position.direction_to(agent.get_next_location())
					velocity = velocity.move_toward(direction * MAX_SPEED, ACCEL *  delta)
					sprite.play("Run")
				else:
					state = IDLE
				

	sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)
		

	
func _on_Hurtbox_area_entered(area):
	sprite.material.set_shader_param("hit_opacity", 1)
	hitstun = 10
	

func update_pathfinding(position) -> void:
	if is_instance_valid(player) and can_update_pathfinding:
		agent.set_target_location(position)
		can_update_pathfinding = false
		pathTimer.start()

func can_see_player() -> bool:
	var collider = sight.get_collider()
	if collider and collider.is_in_group("Player"):
		return true
	return false

func _on_PathTimer_timeout():
	can_update_pathfinding = true
	
func update_target_position():
	targetPosition = startPosition + Vector2(rand_range(-wanderRange, wanderRange), rand_range(-wanderRange, wanderRange))

func _on_WanderTimer_timeout():
	if state != CHASE:
		update_target_position()
		update_pathfinding(targetPosition)
