extends KinematicBody2D

var hitstun: int = 0
var velocity: Vector2 = Vector2.ZERO
var max_hp: int = 45
var current_hp: int
var knockback_impulse: Vector2
var can_update_pathfinding: bool = true
var idle_states: Array = [IDLE, WANDER]
var distance_to_player: int
var can_attack: bool = true
var experience_dropped: int = 80



const MAX_SPEED = 45
const ACCEL = 150
const MAX_DISTANCE_TO_PLAYER = 150
const MIN_DISTANCE_TO_PLAYER = 75

export (int) var wanderRange = 10
export var path_to_player = NodePath()
export (int) var spearspeed = 100
export (float) var attack_speed

onready var player = get_node(path_to_player)
onready var hurtbox = $Hurtbox
onready var sprite = $AnimatedSprite
onready var healthBar = $ProgressBar
onready var healthBarTween = $ProgressBar/Tween
onready var agent = $NavigationAgent2D
onready var pathTimer = $PathTimer
onready var sight = $LineOfSight
onready var wanderTimer = $WanderTimer
onready var attackTimer = $AttackTimer
onready var spear = preload("res://Scenes/Enemies/Spear.tscn")
onready var start_position = global_position
onready var target_position = global_position

enum {
	IDLE,
	WANDER,
	CHASE
	ATTACK
	HURT
	DEAD
}

var state = IDLE

func _ready() -> void:
	current_hp = max_hp
	_update_distance_to_player()
	
func _drop_coin() -> void:
	"""
	aktiveras när död för att droppa en coin
	"""
	var coin = preload("res://Scenes/Coin.tscn").instance()
	coin.position = global_position
	get_parent().add_child(coin)
	
func take_damage(damage: int) -> void:
	"""
	anropas när tar skada, kontrollerar om död och uppdaterar healthbar
	"""
	current_hp -= damage
	if current_hp <= 0:
		state = DEAD
	else:
		state = HURT
	if healthBar.visible == false:
		healthBar.visible = true
	var hp_percent = int((float(current_hp) / max_hp) * 100)
	healthBarTween.interpolate_property(healthBar, "value", healthBar.value, hp_percent, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	healthBarTween.start()


func set_knockback_stats(impulse: Vector2) -> void:
	"""
	aktiveras för att sätta knockback stats
	"""
	knockback_impulse = impulse


func _physics_process(delta: float) -> void:
	"""
	called every frame
	state machine med match statements, flippar spriten och rör på gubben
	"""
	match state:
		IDLE:
			_idle_state(delta)
		WANDER:
			_wander_state(delta)
		CHASE:
			_chase_state(delta)	
		ATTACK:
			_attack_state(delta)
		HURT:
			_hurt_state()
		DEAD:
			_dead_state()
						
				
	sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)
		
func _idle_state(delta: float) -> void:
	"""
	ser till att den inte rör på sig, kollar efter spelaren, om kan se spelaren byt till chase
	kan även gå in i wander när wandertimern tar slut
	"""
	sprite.play("Idle")
	velocity = velocity.move_toward(Vector2.ZERO, ACCEL * delta)
	_look_at_player()
	if _can_see_player() and distance_to_player > MAX_DISTANCE_TO_PLAYER:
		state = CHASE
	if _can_see_player() and distance_to_player < MIN_DISTANCE_TO_PLAYER:
		state = CHASE
	if _can_see_player() and distance_to_player < MAX_DISTANCE_TO_PLAYER and distance_to_player > MIN_DISTANCE_TO_PLAYER:
		state = ATTACK
		
	if not _can_see_player() and wanderTimer.time_left == 0:		
		state = idle_states[randi() % idle_states.size()]
		wanderTimer.start(rand_range(1, 3))

func _wander_state(delta: float) -> void:
	"""
	vandrar till en slumpmässig koordinat nära startpositionen
	om kan se spelaren gå in i chase
	"""
	_look_at_player()
	if _can_see_player() and distance_to_player > MAX_DISTANCE_TO_PLAYER:
		state = CHASE
	if _can_see_player() and distance_to_player < MIN_DISTANCE_TO_PLAYER:
		state = CHASE
	if _can_see_player() and distance_to_player < MAX_DISTANCE_TO_PLAYER and distance_to_player > MIN_DISTANCE_TO_PLAYER:
		state = ATTACK
	
	if wanderTimer.time_left == 0:
		state = idle_states[randi() % idle_states.size()]			
		wanderTimer.start(rand_range(1, 3))
		
	var direction = global_position.direction_to(agent.get_next_location())
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCEL *  delta)
	sprite.play("Run")
	
	if agent.is_navigation_finished():
		state = idle_states[randi() % idle_states.size()]
		wanderTimer.start(rand_range(1, 3))
	
func _chase_state(delta: float) -> void:
	"""
	jagar efter spelaren, om inte kan se spelaren gå tillbaka in i idle
	"""
	_look_at_player()
	if _can_see_player() and distance_to_player < MAX_DISTANCE_TO_PLAYER and distance_to_player > MIN_DISTANCE_TO_PLAYER:
		state = ATTACK
	if !_can_see_player():
		state = IDLE
	
	if _can_see_player() and distance_to_player > MAX_DISTANCE_TO_PLAYER:
		_update_pathfinding(player.global_position)
		var direction = global_position.direction_to(agent.get_next_location())
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCEL *  delta)
		sprite.play("Run")
		
	
	if _can_see_player() and distance_to_player < MIN_DISTANCE_TO_PLAYER:
		_update_pathfinding((global_position - player.global_position).normalized() * 100)
		var direction = global_position.direction_to(agent.get_next_location())
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCEL *  delta)
		sprite.play("Run")	

func _attack_state(delta: float) -> void:
	"""
	aktiveras när zombie befinner sig på ett komfortabelt avstånd från spelare
	om can_attack kasta spjut
	om inte kan se spelaren gå in i idle
	om avståndet inte är komfortabelt längre gör det komfortabelt genom att gå in i chase
	"""
	velocity = velocity.move_toward(Vector2.ZERO, ACCEL * delta)
	sprite.play("Idle")
	if _can_see_player() and can_attack:
		can_attack = false
		throw_spear()
		attackTimer.start(attack_speed)
	if _can_see_player() and distance_to_player > MAX_DISTANCE_TO_PLAYER:
		state = CHASE
	if _can_see_player() and distance_to_player < MIN_DISTANCE_TO_PLAYER:
		state = CHASE
	if !_can_see_player():
		state = IDLE


func _hurt_state() -> void:
	"""
	aktiveras när tar skada, kontrollerar velocity vid knockback och hurt effect
	"""
	if hitstun > 0:
		hitstun -= 1
		knockback_impulse = lerp(knockback_impulse, Vector2.ZERO, 0.1)
		velocity = knockback_impulse
		
	if hitstun == 0:
		sprite.material.set_shader_param("hit_opacity", 0)
		state = IDLE
	
	
	
func _dead_state() -> void:
	"""
	går in i detta state när död, ger spelaren xp och försvinner (droppar coin)
	"""
	player.gain_experience(experience_dropped)
	call_deferred("_drop_coin")
	queue_free()
	
func _on_Hurtbox_area_entered(area: Area2D):
	"""
	aktiveras när tar skada
	"""
	sprite.material.set_shader_param("hit_opacity", 1)
	hitstun = 10
	

func _update_pathfinding(position: Vector2) -> void:
	"""
	uppdaterar pathfinding om can update pathfinding är sann, called av olika states
	"""
	if is_instance_valid(player) and can_update_pathfinding:
		agent.set_target_location(position)
		can_update_pathfinding = false
		pathTimer.start()

func _can_see_player() -> bool:
	"""
	kontrollerar om kan se spelaren
	"""
	var collider = sight.get_collider()
	if collider and collider.is_in_group("Player"):
		return true
	return false

func _look_at_player() -> void:
	"""
	riktar raycast mot spelaren
	"""
	if is_instance_valid(player):
		sight.look_at(player.global_position + Vector2(0, 6))

func _on_PathTimer_timeout():
	can_update_pathfinding = true
	
func _update_target_position():
	target_position = start_position + Vector2(rand_range(-wanderRange, wanderRange), rand_range(-wanderRange, wanderRange))

func _update_distance_to_player():
	"""
	uppdaterar avståndet till spelaren
	"""
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()

func _on_WanderTimer_timeout():
	if state == IDLE or state == WANDER:
		_update_target_position()
		_update_pathfinding(target_position)

func _on_UpdateDistanceTimer_timeout():
	_update_distance_to_player()

func _on_AttackTimer_timeout():
	can_attack = true

func throw_spear() -> void:
	"""
	kastar ett spjut mot spelaren, riktar det mot spelaren och ställer in dess hastighet
	"""
	var projectile = spear.instance()
	projectile.position = global_position
	projectile.spear_speed = spearspeed
	projectile.direction = global_position.direction_to(player.global_position)
	add_child(projectile)
	
