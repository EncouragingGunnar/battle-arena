extends Node

signal items_changed(indexes)

var items = [
	null, null, null, null, preload("res://Resources/Items/Gloves.tres"), null, null, preload("res://Resources/Items/Gem.tres"), null, null, null, null
	]

func set_item(item_index, item):
	var previous_item = items[item_index]
	items[item_index] = item
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
	
func set_item_quantity(index, amount):
	items[index].quantity += amount
	if items[index].quantity <= 0:
		remove_item(items[index])
	else:
		emit_signal("items_changed", [index])
		
func pick_up_item(picked_item):
	for item in items:
		if item == null:
			items[item] = picked_item
			return			
	return null
	
