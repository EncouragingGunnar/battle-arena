extends Area2D

export (Resource) var itemresource
onready var sprite = $Sprite
onready var tween = $Tween

var throw_direction: Vector2

func _ready() -> void:
	var target_location = global_position + throw_direction * 30
	sprite.texture = itemresource.texture
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(8, 8))
	var collision = CollisionShape2D.new()
	collision.set_shape(shape)
	add_child(collision)
	tween.interpolate_property(self, "position:x", position.x, target_location.x, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(self, "position:y", position.y, target_location.y - 10, 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, "position:y", target_location.y - 10, target_location.y, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN, 0.4)
	tween.interpolate_property(self, "position:y", target_location.y, target_location.y - 5, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN, 0.8)
	tween.interpolate_property(self, "position:y", target_location.y - 5, target_location.y, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN, 0.9)
	tween.start()
	yield(tween, "tween_completed")
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("WorldObject"):
		print("trets")
		tween.stop_all()
		set_collision_mask_bit(3, false)
	if body.is_in_group("Player"):
		var empty_slot_index = body.Inventory.check_if_can_pick_up_item(itemresource)
		if empty_slot_index != null:
			body.Inventory.pick_up_item(empty_slot_index, itemresource)
			tween.stop_all()
			tween.interpolate_property(sprite, "scale", Vector2(1, 1), Vector2.ZERO, 0.1, Tween.TRANS_LINEAR)
			tween.interpolate_property(self, "position", global_position, body.global_position, 0.1, Tween.TRANS_LINEAR)
			tween.start()
			yield(tween, "tween_completed")
			queue_free()

