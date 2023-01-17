extends KinematicBody2D

var hitstun = 0
var velocity = Vector2.ZERO
var max_hp = 300
var current_hp
var knockbackImpulse
var attackStates = [IDLE, CHARGE, SPAWN]
var chargedIntoWall = false
var experience_dropped = 400

const CHARGE_MAX_SPEED = 200
const CHARGE_ACCEL = 400


export var path_to_player = NodePath()

onready var player = get_node(path_to_player)
onready var hurtbox = $Hurtbox
onready var sprite = $AnimatedSprite
onready var healthBar = $ProgressBar
onready var healthBarTween = $ProgressBar/Tween
onready var sight = $LineOfSight
onready var attackTimer = $AttackTimer
onready var chargeTween = $ChargeTween
onready var spear = preload("res://Scenes/Enemies/Spear.tscn")
onready var startPosition = global_position
onready var monsterPosition = $MonsterPosition
onready var monsterPosition2 = $MonsterPosition2
onready var hitbox = $Hitbox/CollisionShape2D
onready var zombie = preload("res://Scenes/Enemies/Zombie.tscn")

enum {
	IDLE,
	CHARGE,
	SPAWN	
}

var state = IDLE

func _ready():
	current_hp = max_hp
	attackTimer.start()

func drop_coin():
	var coin = preload("res://Scenes/Coin.tscn").instance()
	coin.position = global_position
	get_parent().add_child(coin)
	
func take_damage(damage):
	if healthBar.visible == false:
		healthBar.visible = true
	current_hp -= damage
	var hpPercent = int((float(current_hp) / max_hp) * 100)
	healthBarTween.interpolate_property(healthBar, "value", healthBar.value, hpPercent, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	healthBarTween.start()
	if current_hp <= 0:
		die()
		
func die():
	player.gain_experience(experience_dropped)
	for _i in range(5):
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
			if is_instance_valid(player):
				sight.look_at(player.global_position)
				if can_see_player() and is_equal_approx(attackTimer.time_left, 0.0):
					state = attackStates[randi() % attackStates.size()]
					attackTimer.start()
			
			
		CHARGE:
			sprite.play("Run")
			if is_instance_valid(player):
				sight.look_at(player.global_position)
				if can_see_player() and attackTimer.time_left > attackTimer.wait_time / 2:
					var direction = global_position.direction_to(player.global_position)
					velocity = velocity.move_toward(direction * CHARGE_MAX_SPEED, CHARGE_ACCEL *  delta)
					velocity = move_and_slide(velocity)
						
				elif attackTimer.time_left < attackTimer.wait_time / 2:
					velocity = Vector2.ZERO
					chargeTween.interpolate_property(self, "position", global_position, startPosition, attackTimer.wait_time / 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					chargeTween.start()
				
					state = attackStates[randi() % attackStates.size()]
					attackTimer.start()

		SPAWN:
			sprite.play("Idle")
			if is_instance_valid(player):
				sight.look_at(player.global_position)				
				if can_see_player() and is_equal_approx(attackTimer.time_left, 0.0):
					_spawn_monsters()
					state = attackStates[randi() % attackStates.size()]
					attackTimer.start()
		
	sprite.flip_h = velocity.x < 0
	
		

	
func _on_Hurtbox_area_entered(area):
	sprite.material.set_shader_param("hit_opacity", 1)
	hitstun = 10
	

func can_see_player() -> bool:
	var collider = sight.get_collider()
	if collider and collider.is_in_group("Player"):
		return true
	return false

	
func _spawn_monsters() -> void:
	var monster1 = zombie.instance()
	var monster2 = zombie.instance()
	monster1.path_to_player = path_to_player
	monster2.path_to_player = path_to_player
	monster1.global_position = monsterPosition.global_position
	monster2.global_position = monsterPosition2.global_position
	get_parent().add_child(monster1)
	get_parent().add_child(monster2)
