extends Area2D

onready var tween = $Tween
onready var animatedsprite = $AnimatedSprite
var drop_range = 20

func _ready():
	randomize()
	var target_location = Vector2(position.x + rand_range(-drop_range, drop_range), position.y + rand_range(-drop_range, drop_range))
	tween.interpolate_property(self, "position", global_position, target_location, 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	

func _on_Coin_body_entered(body):
	if body.is_in_group("WorldObject"):
		tween.stop_all()
		set_collision_mask_bit(3, false)
	if body.has_method("collect_coin"):
		tween.stop_all()
		tween.interpolate_property(animatedsprite, "scale", Vector2(1, 1), Vector2.ZERO, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		body.collect_coin()
		queue_free()
		
		
