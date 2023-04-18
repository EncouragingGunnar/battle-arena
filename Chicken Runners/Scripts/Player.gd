class_name Player
extends KinematicBody2D

signal health_changed(health)
#signal mana_changed(mp, max_mp)
signal coins_changed()
signal xp_changed()
signal leveled_up()

export (Resource) var playerstats

var in_inventory: bool = false
var can_input: bool = true
var can_roll: bool = true

var experience := 0
var experience_required: int 

var velocity: Vector2 = Vector2()

var current_hp: int
var current_mp: int
var combat_time: int = 4

var Inventory = preload("res://Resources/Items/Inventory.tres")

onready var dropped_item = preload("res://Scenes/Inventory/DroppedItem.tscn")
onready var animationPlayer = $AnimationPlayer2
onready var animationTree = $AnimationTree3
onready var animationState = animationTree.get("parameters/AnimationNodeStateMachine/playback")
onready var stateMachine = $StateMachine
onready var Arrow = preload("res://Scenes/Arrow.tscn")
onready var arrowPosition = $ArrowStartPosition
onready var swordHitbox = $SlashHitboxPosition/Hitbox1/CollisionShape2D
onready var swordHitbox2 = $SlashHitboxPosition/Hitbox2/CollisionShape2D
onready var collisionShape = $CollisionShape2D
onready var Inventorycontainer = $GUI/InventoryContainer
onready var combat_timer = $CombatTimer
onready var hurtbox = $Hurtbox
onready var sprite = $Sprite2



func _ready() -> void:
	"""
	ställer in nödvändiga variabler
	"""
	randomize()
	animationTree.active = true
	animationTree.set("parameters/TimeScale/scale", playerstats.animation_speed)
	swordHitbox.set_deferred("disabled", true)
	swordHitbox2.set_deferred("disabled", true)
	current_hp = playerstats.max_hp
	current_mp = playerstats.max_mp
	$SlashHitboxPosition/Hitbox2.damage = playerstats.melee_damage
	$SlashHitboxPosition/Hitbox2.knockback_strength = playerstats.player_knockback_strength
	hurtbox.knockback_resistance = playerstats.player_knockback_resistance
	experience_required = get_required_xp_to_level_up()
	Inventory.connect("item_dropped", self, "_on_items_dropped")
	Inventory.connect("item_equipped", self, "_on_items_equipped")
	Inventory.connect("item_unequipped", self, "_on_items_unequipped")
	Inventory.connect("item_used", self, "_on_item_used")
	
	
func _on_RollTimer_timeout() -> void:
	"""
	rolltimer aktiveras av roll state
	"""
	can_roll = true

func take_damage(damage: int) -> void:
	"""
	tar in damage
	sänker current hp med damage delat med defense, signalerar till hud
	kontrollerar om död
	"""
	current_hp -= int(damage / float(playerstats.defense))
	emit_signal("health_changed", current_hp, playerstats.max_hp)
	combat_timer.start(combat_time)
	if current_hp <= 0:
		die()
		
func die() -> void:
	"""
	om död ladda in game over menu
	"""
	queue_free()
	Transition.load_scene("res://Scenes/Menus/GameOverMenu.tscn")

func gain_health(hp) -> void:
	"""
	liknande funktion som take damage, men kontrollerar mot max hp
	"""
	if hp + current_hp >= playerstats.max_hp:
		current_hp = playerstats.max_hp
	else:
		current_hp += hp
	emit_signal("health_changed", current_hp, playerstats.max_hp)
	
func set_max_hp(max_hp: int) -> void:
	"""
	ändrar max hp till nya max hp, tar in ett nytt max hp
	"""
	playerstats.max_hp = max_hp
	if current_hp > max_hp:
		current_hp = max_hp
	emit_signal("health_changed", current_hp, max_hp)

func set_knockback_stats(impulse: Vector2) -> void:
	"""
	går in i hurt state sätter knockback stats till impulse
	"""
	stateMachine.transition_to("Hurt", {knockback_stats = impulse})
	
func input_ready() -> void:
	"""
	anropas av states
	"""
	can_input = true
	
func collect_coin() -> void:
	"""
	tar upp en coin
	"""
	Globals.coins += 1
	emit_signal("coins_changed")
	
func get_required_xp_to_level_up() -> int:
	"""
	får ut krävd xp för att levla upp enligt en avancerad algoritm
	"""
	return int(round(pow(Globals.level, 1.4) * 10))

func gain_experience(experience_gained: int) -> void:
	"""
	tar in experience gained, anropas av monster när de dör
	kontrollerar om experience är större än krävd experience
	om den är levla upp
	och skicka signal xp changed för att uppdatera hud
	"""
	experience += experience_gained
	while experience >= experience_required:
		experience -= experience_required
		level_up()
	emit_signal("xp_changed", experience, experience_required)

func level_up() -> void:
	"""
	ökar level med 1, ökar hp och experience required
	"""
	Globals.level += 1
	experience_required = get_required_xp_to_level_up()
	emit_signal("leveled_up")
	playerstats.max_hp += 5
	current_hp = playerstats.max_hp
	emit_signal("health_changed", playerstats.max_hp, playerstats.max_hp)
	
func _on_items_dropped(index: int) -> void:
	"""
	droppar ett item från inventory genom att ta det håll man tittar
	droppar åt det hållet och ger droppeditem en itemresource med item som droppas
	ta sedan bort item från inventory
	"""
	var item = Inventory.items[index]
	Inventory.remove_item(index)
	var droppeditem = dropped_item.instance()
	droppeditem.throw_direction = animationTree.get("parameters/AnimationNodeStateMachine/Idle/blend_position")
	droppeditem.position = global_position + (animationTree.get("parameters/AnimationNodeStateMachine/Idle/blend_position") * 20)
	droppeditem.itemresource = item
	get_parent().add_child(droppeditem)
	
func change_hit_opacity(value: float) -> void:
	"""
	ändrar sprite färg till vit för hit effect, anropas av hurt state
	"""
	sprite.material.set_shader_param("hit_opacity", value)

func _on_items_equipped(item: EquipmentItem) -> void:
	"""
	ökar stats med de stats item har, tar in ett equipmentitem
	"""
	playerstats.melee_damage += item.melee_damage_increase
	playerstats.bow_damage += item.bow_damage_increase
	playerstats.melee_attack_speed += item.melee_attack_speed_increase
	playerstats.defense += item.defense_increase
	set_max_hp(playerstats.max_hp + item.max_health_increase)
	playerstats.bow_attack_speed += item.bow_attack_speed_increase
	hurtbox.knockback_resistance += item.knockback_resistance_increase
	$SlashHitboxPosition/Hitbox2.knockback_strength += item.knockback_strength_increase
	playerstats.max_mp += item.max_mana_increase
	#if item.max_mana_increase > 0:
		#emit_signal("mana_changed", current_mp, playerstats.max_mp)

func _on_items_unequipped(item: EquipmentItem) -> void:
	"""
	minskar stats med de stats item har, tar in ett equipmentitem
	"""
	playerstats.melee_damage -= item.melee_damage_increase
	playerstats.bow_damage -= item.bow_damage_increase
	playerstats.melee_attack_speed -= item.melee_attack_speed_increase
	playerstats.defense -= item.defense_increase
	set_max_hp(playerstats.max_hp - item.max_health_increase)
	playerstats.bow_attack_speed -= item.bow_attack_speed_increase
	hurtbox.knockback_resistance -= item.knockback_resistance_increase
	$SlashHitboxPosition/Hitbox2.knockback_strength -= item.knockback_strength_increase
	playerstats.max_mp -= item.max_mana_increase
	#if item.max_mana_increase > 0:
		#emit_signal("mana_changed", current_mp, playerstats.max_mp)

func _on_item_used(index: int) -> void:
	"""
	ökar stats med de som item har och tar bort en av dem för att det användes
	"""
	var item = Inventory.items[index]
	if item.experience_receive > 0:
		gain_experience(item.experience_receive)
		Inventory.change_item_quantity(index, -1)
	if current_hp < playerstats.max_hp or current_mp < playerstats.max_mp:
		if item.hp_restore > 0:
			gain_health(item.hp_restore)
			Inventory.change_item_quantity(index, -1)
	
	#current_mp += item.mana_restore
	
