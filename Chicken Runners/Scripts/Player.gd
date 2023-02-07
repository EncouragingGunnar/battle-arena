class_name Player
extends KinematicBody2D

signal health_changed(health)
signal mana_changed(mp, max_mp)
signal coins_changed()
signal xp_changed()
signal leveled_up()

export (Resource) var playerstats

var can_input = true
var can_roll = true

var experience := 0
var experience_required 

var velocity = Vector2()

var current_hp
var current_mp

var Inventory = preload("res://Resources/Items/Inventory.tres")

onready var droppedItem = preload("res://Scenes/Inventory/DroppedItem.tscn")
onready var animationPlayer = $AnimationPlayer2
onready var animationTree = $AnimationTree3
onready var animationState = animationTree.get("parameters/AnimationNodeStateMachine/playback")
onready var stateMachine = $StateMachine
onready var Arrow = preload("res://Scenes/Arrow.tscn")
onready var arrowPosition = $ArrowStartPosition
onready var swordHitbox = $SlashHitboxPosition/Hitbox1/CollisionShape2D
onready var swordHitbox2 = $SlashHitboxPosition/Hitbox2/CollisionShape2D
onready var collisionShape = $CollisionShape2D
onready var hurtbox = $Hurtbox
onready var sprite = $Sprite2

func _ready():
	randomize()
	animationTree.active = true
	swordHitbox.set_deferred("disabled", true)
	swordHitbox2.set_deferred("disabled", true)
	current_hp = playerstats.max_hp
	current_mp = playerstats.max_mp
	experience_required = get_required_xp_to_level_up(2)
	Inventory.connect("item_dropped", self, "_on_items_dropped")
	Inventory.connect("item_equipped", self, "_on_items_equipped")
	Inventory.connect("item_unequipped", self, "_on_items_unequipped")
	Inventory.connect("item_used", self, "_on_item_used")
	
	
func _on_RollTimer_timeout() -> void:
	can_roll = true

func take_damage(damage: int) -> void:
	current_hp -= damage
	emit_signal("health_changed", current_hp, playerstats.max_hp)
	if current_hp <= 0:
		die()
		
func die() -> void:
	queue_free()
	Transition.load_scene("res://Scenes/Menus/GameOverMenu.tscn")

func gain_health(hp) -> void:
	if hp + current_hp >= playerstats.max_hp:
		current_hp = playerstats.max_hp
	else:
		current_hp += hp
	emit_signal("health_changed", current_hp, playerstats.max_hp)
	
func set_max_hp(max_hp) -> void:
	playerstats.max_hp = max_hp
	if current_hp > max_hp:
		current_hp = max_hp
	emit_signal("health_changed", current_hp, max_hp)

func set_knockback_stats(impulse) -> void:
	stateMachine.transition_to("Hurt", {knockback_stats = impulse})
	
func input_ready() -> void:
	can_input = true
	
func collect_coin() -> void:
	Globals.coins += 1
	emit_signal("coins_changed")
	
func get_required_xp_to_level_up(level_to: int) -> int:
	return int(round(pow(Globals.level, 1.4) * 10))

func gain_experience(experience_gained: int):
	experience += experience_gained
	while experience >= experience_required:
		experience -= experience_required
		level_up()
	emit_signal("xp_changed", experience, experience_required)

func level_up() -> void:
	Globals.level += 1
	experience_required = get_required_xp_to_level_up(Globals.level + 1)
	emit_signal("leveled_up")
	playerstats.max_hp += 5
	current_hp = playerstats.max_hp
	emit_signal("health_changed", playerstats.max_hp, playerstats.max_hp)
	
func _on_items_dropped(index: int) -> void:
	var item = Inventory.items[index]
	Inventory.remove_item(index)
	var droppeditem = droppedItem.instance()
	droppeditem.position = global_position + (animationTree.get("parameters/AnimationNodeStateMachine/Idle/blend_position") * 50)
	droppeditem.itemresource = item
	get_parent().add_child(droppeditem)
	
func change_hit_opacity(value: float) -> void:
	sprite.material.set_shader_param("hit_opacity", value)

func _on_items_equipped(item: EquipmentItem) -> void:
	playerstats.melee_damage += item.melee_damage
	playerstats.bow_damage += item.bow_damage
	#item.melee_attack_speed
	#item.defense
	set_max_hp(playerstats.max_hp + item.max_health_increase)
	#item.bow_attack_speed
	hurtbox.knockback_resistance += item.knockback_resistance_increase
	$SlashHitboxPosition/Hitbox2.knockback_strength += item.knockback_strength_increase
	playerstats.max_mp += item.max_mana_increase
	if item.max_mana_increase > 0:
		emit_signal("mana_changed", current_mp, playerstats.max_mp)

func _on_items_unequipped(item: EquipmentItem) -> void:
	playerstats.melee_damage -= item.melee_damage
	playerstats.bow_damage -= item.bow_damage
	#item.melee_attack_speed
	#item.defense
	set_max_hp(playerstats.max_hp - item.max_health_increase)
	#item.bow_attack_speed
	hurtbox.knockback_resistance -= item.knockback_resistance_increase
	$SlashHitboxPosition/Hitbox2.knockback_strength -= item.knockback_strength_increase
	playerstats.max_mp -= item.max_mana_increase
	if item.max_mana_increase > 0:
		emit_signal("mana_changed", current_mp, playerstats.max_mp)

func _on_item_used(index: int) -> void:
	var item = Inventory.items[index]
	if current_hp < playerstats.max_hp or current_mp < playerstats.max_mp:
		Inventory.change_item_quantity(index, -1)
	if item.hp_restore > 0:
		gain_health(item.hp_restore)
	if item.experience_receive > 0:
		gain_experience(item.experience_receive)
	#current_mp += item.mana_restore
	
