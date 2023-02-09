extends Area2D

export (Resource) var itemresource
onready var sprite = $Sprite
onready var tween = $Tween

func _ready() -> void:
	sprite.texture = itemresource.texture
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(8, 8))
	var collision = CollisionShape2D.new()
	collision.set_shape(shape)
	add_child(collision)
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("WorldObject"):
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

