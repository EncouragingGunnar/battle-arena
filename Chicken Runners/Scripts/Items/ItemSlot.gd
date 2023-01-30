extends PanelContainer

onready var itemtexture = $MarginContainer/ItemTexture
onready var amountlabel = $MarginContainer/ItemTexture/AmountLabel
onready var iteminfo = get_parent().get_parent().get_node("ItemInfo")

onready var Inventory = preload("res://Resources/Items/Inventory.tres")

export (int) var slot_number
enum slottype {
	NECKLACE
	GEM
	GLOVE
	RING
	SCROLL
	SPELLBOOK
	UNIVERSAL
}

export (slottype) var slot_type
export (Texture) var slot_texture

var can_split = true

func display_item(item):
	if item and item.stack_size > 1:
		itemtexture.texture = item.texture
		amountlabel.text = str(item.amount)
	elif item:
		itemtexture.texture = item.texture
		amountlabel.text = ""
	elif slot_type != 6:
		itemtexture.texture = slot_texture
		amountlabel.text = ""
	else:
		itemtexture.texture = null
		amountlabel.text = ""

func get_drag_data(_position):
	var item_index = slot_number
	var item = Inventory.items[item_index]
	if item != null:
		var data = {}
		data.item = item
		data.item_index = item_index
		var previewControl = Control.new() 
		var dragPreview = TextureRect.new()
		dragPreview.expand = true
		dragPreview.rect_size = Vector2(48, 48)
		previewControl.add_child(dragPreview)
		dragPreview.texture = item.texture
		dragPreview.rect_position -= dragPreview.rect_size * 0.5
		set_drag_preview(previewControl)
		return data
		
func can_drop_data(_position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has("item")

func drop_data(_position, data):
	var item_index = data.get("item_index")
	var new_index = slot_number
	var item = Inventory.items[item_index]
	var new_item = Inventory.items[new_index]
	
	if item_index == new_index:
		pass	
	
	elif slot_type != 6:
		if item.itemtype == slot_type:
			Inventory.swap_items(item_index, new_index)
			#add equipment slots
		

	else:
		if new_item != null and item.name == new_item.name and item.stack_size > 1:
			if item.amount + new_item.amount <= item.stack_size:
				Inventory.change_item_quantity(new_index, item.amount)
				Inventory.remove_item(item_index)

			elif item.amount == item.stack_size or new_item.amount == new_item.stack_size:
				Inventory.swap_items(item_index, new_index)

			elif item.amount + new_item.amount >= item.stack_size:
				var value_to_add = new_item.stack_size - new_item.amount
				Inventory.change_item_quantity(new_index,  value_to_add)
				Inventory.change_item_quantity(item_index, -1 * (value_to_add))
		else:
			Inventory.swap_items(new_index, item_index)
	

func _on_ItemSlot_gui_input(event):
	if Inventory.items[slot_number] != null:
		if Input.is_action_pressed("Drop"):
			Inventory.drop_item(slot_number, Inventory.items[slot_number].amount)

		if Input.is_action_pressed("Split") and Inventory.items.find(null, 0) != -1 and can_split:
			can_split = false
			var item = Inventory.items[slot_number]
			if item.amount > 1:
				var split_amount = int(item.amount / 2)
				var other_split_amount = item.amount - split_amount
				var empty_slot_index = Inventory.check_if_can_pick_up_item(item)
				if empty_slot_index != null:
					Inventory.pick_up_item(empty_slot_index, item)
				Inventory.change_item_quantity(empty_slot_index, -1 *  split_amount)
				Inventory.change_item_quantity(slot_number, -1 * other_split_amount)
				yield(get_tree().create_timer(2.0), "timeout")
				can_split = true


func _on_ItemSlot_mouse_entered():
	if Inventory.items[slot_number] != null:
		iteminfo.find_node("ItemNameLabel").text = Inventory.items[slot_number].name
		iteminfo.find_node("ItemDescriptionLabel").text = Inventory.items[slot_number].item_description


func _on_ItemSlot_mouse_exited():
	if Inventory.items[slot_number] != null:
		iteminfo.find_node("ItemNameLabel").text = ""
		iteminfo.find_node("ItemDescriptionLabel").text = ""
