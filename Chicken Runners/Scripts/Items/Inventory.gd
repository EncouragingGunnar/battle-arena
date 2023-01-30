class_name Inventory
extends Resource

signal items_changed(indexes)
signal item_dropped(index)
signal item_used(index)
signal item_equipped(index)
signal item_unequipped(index)

var items = [
	null, null, null, preload("res://Resources/Items/Health Potion.tres").duplicate(), null, preload("res://Resources/Items/Gloves.tres").duplicate(), null, null, null, preload("res://Resources/Items/Gem.tres").duplicate(), null, null, null, null, null, null, null, null
	]

var universal_slots = [2, 3, 4, 5, 8, 9, 10, 11, 14, 15, 16, 17]
var equipment_slots = [0, 1, 6, 7, 12, 13]

func set_item(item_index, item):
	var previous_item = items[item_index]
	items[item_index] = item.duplicate()
	emit_signal("items_changed", [item_index])
	return previous_item
	
func swap_items(item_index, other_item_index):
	var target_item = items[other_item_index]
	items[other_item_index] = items[item_index]
	items[item_index] = target_item
	emit_signal("items_changed", [other_item_index, item_index])
	
func remove_item(item_index):
	var previous_item = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previous_item
	
func change_item_quantity(index, amount):
	items[index].amount += amount
	if items[index].amount <= 0:
		remove_item(index)
		emit_signal("items_changed", [index])
	else:
		emit_signal("items_changed", [index])

func check_if_can_pick_up_item(item):
	for index in universal_slots:
		if items[index] == null:
			return index

func pick_up_item(empty_slot_index, item):
	set_item(empty_slot_index, item)

func drop_item(index, amount):
	emit_signal("item_dropped", index, amount)
	
func use_item(index):
	change_item_quantity(index, -1)

func equip_item(index):
	pass
	
func unequip_item(index):
	pass
