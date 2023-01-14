extends Area2D

var itemresource
onready var sprite = $Sprite


func _on_Area2D_area_entered(area):
	if area.has_method("pick_up_item"):
		Inventory.pick_up_item(itemresource)
		queue_free()
