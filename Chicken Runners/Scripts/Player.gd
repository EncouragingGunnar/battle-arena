class_name Player
extends KinematicBody2D

signal health_changed(health)
signal mana_changed(mana)
signal coins_changed()
signal xp_changed()
signal leveled_up()

export (Resource) var playerstats

export var hitstun = 0
var canInput = true

var experience_required 


var velocity = Vector2()
var knockbackImpulse = Vector2()


var current_hp

onready var animationPlayer = $AnimationPlayer2
onready var animationTree = $AnimationTree2
onready var animationState = animationTree.get("parameters/playback")
onready var stateMachine = $StateMachine
onready var Arrow = preload("res://Scenes/Arrow.tscn")
onready var arrowPosition = $ArrowStartPosition
onready var swordHitbox = $SlashHitboxPosition/Hitbox1/CollisionShape2D
onready var swordHitbox2 = $SlashHitboxPosition/Hitbox2/CollisionShape2D
onready var collisionShape = $CollisionShape2D
onready var hurtbox = $Hurtbox
onready var sprite = $Sprite2




var can_roll = true

func _ready():
	randomize()
	animationTree.active = true
	swordHitbox.set_deferred("disabled", true)
	swordHitbox2.set_deferred("disabled", true)
	current_hp = playerstats.max_hp
	experience_required = get_required_xp_to_level_up(2)
	
func _on_RollTimer_timeout():
	can_roll = true

func take_damage(damage):
	current_hp -= damage
	emit_signal("health_changed", current_hp)
	if current_hp <= 0:
		die()
		
func die():
	queue_free()
	Transition.load_scene("res://Scenes/GameOverMenu.tscn")
	
func set_knockback_stats(impulse):
	knockbackImpulse = impulse
	
	
func _physics_process(delta):
	if hitstun > 0:
		hitstun -= 1
		knockbackImpulse = lerp(knockbackImpulse, Vector2.ZERO, 0.1)
		velocity = move_and_slide(knockbackImpulse)
	
	if hitstun == 0:
		sprite.material.set_shader_param("hit_opacity", 0)
		

func _on_Hurtbox_area_entered(area):
	sprite.material.set_shader_param("hit_opacity", 1)
	hitstun = 10

func input_ready():
	canInput = true
	
func collect_coin():
	Globals.coins += 1
	emit_signal("coins_changed")
	
func get_required_xp_to_level_up(level_to):
	return round(pow(playerstats.level, 1.4) * 10)
	
func gain_experience(experience_gained):
	playerstats.experience += experience_gained
	while playerstats.experience >= experience_required:
		playerstats.experience -= experience_required
		level_up()
	emit_signal("xp_changed")
	

		
func level_up():
	playerstats.level += 1
	experience_required = get_required_xp_to_level_up(playerstats.level + 1)
	emit_signal("leveled_up")
	playerstats.max_hp += 5
	current_hp = playerstats.max_hp
	emit_signal("health_changed", playerstats.max_hp)
