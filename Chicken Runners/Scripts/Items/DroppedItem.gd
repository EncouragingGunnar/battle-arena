extends Area2D

export (Resource) var itemresource
onready var sprite = $Sprite
onready var tween = $Tween

func _ready():
	sprite.texture = itemresource.texture
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(8, 8))
	var collision = CollisionShape2D.new()
	collision.set_shape(shape)
	add_child(collision)
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		tween.stop_all()
		tween.interpolate_property(sprite, "scale", Vector2(1, 1), Vector2.ZERO, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		body.Inventory.pick_up_item(itemresource)
		queue_free()

