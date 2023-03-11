extends KinematicBody2D

var hitstun = 0
var velocity = Vector2.ZERO
var max_hp = 300
var current_hp
var knockback_impulse
var attack_states = [IDLE, CHARGE, SPAWN]
var charged_into_wall = false
var experience_dropped = 400

const CHARGE_MAX_SPEED = 200
const CHARGE_ACCEL = 400


export var path_to_player = NodePath()

onready var player = get_node(path_to_player)
onready var hurtbox = $Hurtbox
onready var sprite = $AnimatedSprite
onready var health_bar = $ProgressBar
onready var health_bar_tween = $ProgressBar/Tween
onready var sight = $LineOfSight
onready var attack_timer = $AttackTimer
onready var charge_tween = $ChargeTween
onready var spear = preload("res://Scenes/Enemies/Spear.tscn")
onready var start_position = global_position
onready var monster_position = $MonsterPosition
onready var monster_position2 = $MonsterPosition2
onready var hitbox = $Hitbox/CollisionShape2D
onready var zombie = preload("res://Scenes/Enemies/Zombie.tscn")

enum {
	IDLE,
	CHARGE,
	SPAWN,
	HURT,
	DEAD
}

var state = IDLE

func _ready():
	current_hp = max_hp
	attack_timer.start()

func _drop_coin():
	var coin = preload("res://Scenes/Coin.tscn").instance()
	coin.position = global_position
	get_parent().add_child(coin)
	
func take_damage(damage):
	current_hp -= damage
	if current_hp <= 0:
		state = DEAD
	else:
		state = HURT
	if health_bar.visible == false:
		health_bar.visible = true
	var hp_percent = int((float(current_hp) / max_hp) * 100)
	health_bar_tween.interpolate_property(health_bar, "value", health_bar.value, hp_percent, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	health_bar_tween.start()

	


func set_knockback_stats(impulse):
	knockback_impulse = impulse

func _physics_process(delta):
	match state:
		IDLE:
			_idle_state()
			
		CHARGE:
			_charge_state(delta)

		SPAWN:
			_spawn_state()
		
		HURT:
			_hurt_state()
		
		DEAD:
			_dead_state()
		
	sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)
	
		
func _idle_state() -> void:
	sprite.play("Idle")
	velocity = Vector2.ZERO
	_look_at_player()
	if can_see_player() and is_equal_approx(attack_timer.time_left, 0.0):
			state = attack_states[randi() % attack_states.size()]
			attack_timer.start()

func _charge_state(delta: float) -> void:
	sprite.play("Run")
	_look_at_player()
	if can_see_player() and attack_timer.time_left > attack_timer.wait_time / 2:
		_set_charge_velocity(delta)
					
	elif attack_timer.time_left < attack_timer.wait_time / 2:
		velocity = Vector2.ZERO
		charge_tween.interpolate_property(self, "position", global_position, start_position, attack_timer.wait_time / 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		charge_tween.start()
		state = attack_states[randi() % attack_states.size()]
		attack_timer.start()

func _spawn_state() -> void:
	sprite.play("Idle")
	_look_at_player()			
	if can_see_player() and is_equal_approx(attack_timer.time_left, 0.0):
		_spawn_monsters()
		state = attack_states[randi() % attack_states.size()]
		attack_timer.start()

func _hurt_state() -> void:
	if hitstun > 0:
		hitstun -= 1
		knockback_impulse = lerp(knockback_impulse, Vector2.ZERO, 0.1)
		velocity = knockback_impulse
		
	if hitstun == 0:
		sprite.material.set_shader_param("hit_opacity", 0)
		state = IDLE

func _dead_state() -> void:
	player.gain_experience(experience_dropped)
	for _i in range(5):
		call_deferred("_drop_coin")
	queue_free()
	
func _on_Hurtbox_area_entered(_area):
	sprite.material.set_shader_param("hit_opacity", 1)
	hitstun = 10
	

func can_see_player() -> bool:
	var collider = sight.get_collider()
	if collider and collider.is_in_group("Player"):
		return true
	return false

func _look_at_player() -> void:
	if is_instance_valid(player):
		sight.look_at(player.global_position + Vector2(0, 6))
	
func _set_charge_velocity(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(direction * CHARGE_MAX_SPEED, CHARGE_ACCEL *  delta)

func _spawn_monsters() -> void:
	var monster1 = zombie.instance()
	var monster2 = zombie.instance()
	monster1.path_to_player = path_to_player
	monster2.path_to_player = path_to_player
	monster1.global_position = monster_position.global_position
	monster2.global_position = monster_position2.global_position
	get_parent().add_child(monster1)
	get_parent().add_child(monster2)

