class_name Inventory
extends Resource

"""
Inventory klass, listan items är lista med resurser som är items
universal slots är slots där man kan ha vilket item som helst!
equipment slots är där man har equipment items!
"""

signal items_changed(indexes)
signal item_dropped(index)
signal item_used(index)
signal item_equipped(index)
signal item_unequipped(index)

var items = [
	null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
	]

var universal_slots = [2, 3, 4, 5, 8, 9, 10, 11, 14, 15, 16, 17]
var equipment_slots = [0, 1, 6, 7, 12, 13]

func set_item(item_index: int, item: Item) -> Item:
	"""
	sätter ett föremål på en position i förrådet, tar in ett item som ska sättas in och en position där föremålet ska sättas in
	returnerar föremålet som var på positionen där föremålet sattes in innan
		skickar ut en signal till tomma intet som plockas upp av inventoryslotscontainer
	"""
	var previous_item = items[item_index]
	items[item_index] = item.duplicate()
	emit_signal("items_changed", [item_index])
	return previous_item
	
func swap_items(item_index: int, other_item_index: int) -> void:
	"""
	byter plats på två items i förrådet, tar in två index där det finns items, kan även byta null
	skickar ut en signal till tomma intet som plockas upp av inventoryslotscontainer
	"""
	var target_item = items[other_item_index]
	items[other_item_index] = items[item_index]
	items[item_index] = target_item
	emit_signal("items_changed", [other_item_index, item_index])
	
func remove_item(item_index: int) -> Item:
	"""
	funktion som tar bort ett föremål, tar in ett index och tar bort föremål på det indexet
	returnerar föremålet som fanns där förut
	skickar ut en signal till tomma intet som plockas upp av inventoryslotscontainer
	"""
	var previous_item = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previous_item
	
func change_item_quantity(index: int, amount: int) -> void:
	"""
	ändar mängden av ett föremål som finns på en plats, tar in ett index där föremålet finns och en mängd att ändra med
	kontrollerar så att mängden är större än 0
	uppdaterar display
	"""
	items[index].amount += amount
	if items[index].amount <= 0:
		remove_item(index)
		emit_signal("items_changed", [index])
	else:
		emit_signal("items_changed", [index])

func check_if_can_pick_up_item(item: Item):
	"""
	kontrollerar om det finns plats att plocka upp föremål
	returnerar iddex för den tomma platsen om det finns
	"""
	for index in universal_slots:
		if items[index] == null:
			return index

func pick_up_item(empty_slot_index: int, item: Item) -> void:
	set_item(empty_slot_index, item)

func drop_item(index: int) -> void:
	emit_signal("item_dropped", index)
	
func use_item(index: int) -> void:
	emit_signal("item_used", index)
	
func equip_item(item: Item) -> void:
	emit_signal("item_equipped", item)
	
func unequip_item(item: Item) -> void:
	emit_signal("item_unequipped", item)
