extends Area2D

onready var tween = $Tween
onready var animatedsprite = $AnimatedSprite
var drop_range: int = 20

func _ready() -> void:
	"""
	animerar myntets position till en target location från början för effekt
	"""
	randomize()
	var target_location = Vector2(position.x + rand_range(-drop_range, drop_range), position.y + rand_range(-drop_range, drop_range))
	tween.interpolate_property(self, "position:x", position.x, target_location.x, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(self, "position:y", position.y, target_location.y - 20, 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, "position:y", target_location.y - 20, target_location.y, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN, 0.4)
	tween.interpolate_property(self, "position:y", target_location.y, target_location.y - 5, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN, 0.8)
	tween.interpolate_property(self, "position:y", target_location.y - 5, target_location.y, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN, 0.9)
	tween.start()

func _on_Coin_body_entered(body):
	"""
	om vi tweenar oss in i en vägg, sluta tweena
	"""
	if body.is_in_group("WorldObject"):
		tween.stop_all()
		set_collision_mask_bit(3, false)
	if body is Player:
		"""
		om body är player plocka upp myntet
		"""
		tween.stop_all()
		tween.interpolate_property(animatedsprite, "scale", Vector2(1, 1), Vector2.ZERO, 0.1, Tween.TRANS_LINEAR)
		tween.interpolate_property(self, "position", global_position, body.global_position, 0.1, Tween.TRANS_LINEAR)
		tween.start()
		yield(tween, "tween_completed")
		body.collect_coin()
		queue_free()

