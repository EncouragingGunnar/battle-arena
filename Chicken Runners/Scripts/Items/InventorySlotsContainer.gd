extends GridContainer

onready var Inventory = preload("res://Resources/Items/Inventory.tres")


func _ready() -> void:
	"""
	ansluter signal från inventory, items changed till funktion on item changed
	uppdaterar display för alla föremål i början
	"""
	Inventory.connect("items_changed", self, "_on_items_changed")
	for item_index in Inventory.items.size():
		update_item_slot_display(item_index)
	
func update_item_slot_display(item_index: int) -> void:
	"""
	tar in ett index, tar itemslotdisplay som är samma som det index 
	och anropar funktion display item från itemslotdisplay
	"""
	var itemslotdisplay = get_node("ItemSlot" + str(item_index))
	var item = Inventory.items[item_index]
	itemslotdisplay.display_item(item)
	
func _on_items_changed(indexes: Array) -> void:
	"""
	funktion för att uppdatera flera itemslotdisplay, tar in en lista med ändrade index (lista med int)
	"""
	for item_index in indexes:
		update_item_slot_display(item_index)
	
