extends Node

signal items_changed(indexes)
signal item_dropped(index)

var items = [
	null, preload("res://Resources/Items/Health Potion.tres").duplicate(), null, preload("res://Resources/Items/Gloves.tres").duplicate(), null, null, null, preload("res://Resources/Items/Gem.tres").duplicate(), null, null, null, null
	]

func set_item(item_index, item):
	var previous_item = items[item_index]
	items[item_index] = item.duplicate()
	emit_signal("items_changed", [item_index])
	return previous_item
	
func swap_items(item_index, other_item_index):
	var target_item = items[other_item_index]
	items[other_item_index] = items[item_index]
	items[item_index] = target_item
	emit_signal("items_changed", [item_index, other_item_index])
	
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

func pick_up_item(item):
	var empty_slot = items.find(null, 0)
	if empty_slot != -1:
		set_item(empty_slot, item)

func drop_item(index, amount):
	emit_signal("item_dropped", index, amount)
