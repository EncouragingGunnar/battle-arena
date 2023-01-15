extends Area2D

export (Resource) var itemresource
onready var sprite = $Sprite

func _ready():
	sprite.texture = itemresource.texture
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(14, 14))
	var collision = CollisionShape2D.new()
	collision.set_shape(shape)
	add_child(collision)
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		Inventory.pick_up_item(itemresource)
		queue_free()

