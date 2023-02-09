extends GridContainer

onready var Inventory = preload("res://Resources/Items/Inventory.tres")


func _ready() -> void:
	Inventory.connect("items_changed", self, "_on_items_changed")
	for item_index in Inventory.items.size():
		update_item_slot_display(item_index)
	
func update_item_slot_display(item_index: int) -> void:
	var itemslotdisplay = get_node("ItemSlot" + str(item_index))
	var item = Inventory.items[item_index]
	itemslotdisplay.display_item(item)
	
func _on_items_changed(indexes: Array) -> void:
	for item_index in indexes:
		update_item_slot_display(item_index)
	
