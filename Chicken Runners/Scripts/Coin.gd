extends Area2D

onready var tween = $Tween
var drop_range = 10

func _ready():
	randomize()
	var target_location = Vector2(position.x + rand_range(-drop_range, drop_range), position.y + rand_range(-drop_range, drop_range))
	tween.interpolate_property(self, "position", global_position, target_location, 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	

func _on_Coin_body_entered(body):
	if body.has_method("collect_coin"):
		body.collect_coin()
		queue_free()
		
		
