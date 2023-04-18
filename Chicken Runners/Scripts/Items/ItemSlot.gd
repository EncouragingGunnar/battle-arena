extends PanelContainer

onready var itemtexture = $MarginContainer/ItemTexture
onready var amountlabel = $MarginContainer/ItemTexture/AmountLabel
onready var iteminfo = get_parent().get_parent().get_node("ItemInfo")

onready var Inventory: Inventory = preload("res://Resources/Items/Inventory.tres")

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

var can_use_item: bool = true

func display_item(item: Item) -> void:
	"""
	tar in ett item och visar upp dess texture och amount
	om inget item finns visa inget
	anropas av itemslotcontainer
	"""
	if item and item.get("stack_size"):
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
		
func can_equip_item(item: Item) -> bool:
	"""
	tar in ett item
	kontrollerar om ett equipmentitem kan användas
	"""
	if item is EquipmentItem and item.level_requirement <= Globals.level:
		return true
	return false
		
func item_matches_slot_type(item: Item) -> bool:
	"""
	tar in ett item
	kontrollerar om ett equipmentitem kan flyttas till en viss slot av en viss typ
	"""
	if item.equipment_type == slot_type:
		return true
	return false
	
		
func get_drag_data(_position):
	"""
	inbyggd funktion i godot, tar in position som jag inte använder
	skapar data som dictionary med item och item index
	skapar också en drag preview som använder texture 
	så man kan dra runt föremålet man plockat uppvisuellt
	returnerar data, används i can drop data och drop data
	"""
	var item_index = slot_number
	var item = Inventory.items[item_index]
	if item != null:
		var data = {}
		data.item = item
		data.item_index = item_index
		var previewControl = Control.new() 
		var dragPreview = TextureRect.new()
		previewControl.set_name("DragPreview")
		dragPreview.expand = true
		dragPreview.rect_size = Vector2(48, 48)
		previewControl.add_child(dragPreview)
		dragPreview.texture = item.texture
		dragPreview.rect_position -= dragPreview.rect_size * 0.5
		set_drag_preview(previewControl)
		return data

		
func can_drop_data(_position, data: Dictionary):
	"""
	inbyggd funktion, tar in data, kontrollerar att data är av typen dictionary och att data innehåller item
	"""
	return typeof(data) == TYPE_DICTIONARY and data.has("item")

func drop_data(_position, data: Dictionary) -> void:
	"""
	inbyggd funktion, kallas när man släpper det föremål man drar
	tar in data, letar upp vad som finns på den slot där man befinner sig
	kontrollerar sen om den kan släppa föremålet på en plats
	gör logik med item stacking
	använder funktionerna från inventory
	"""
	var item_index = data.get("item_index")
	var new_index = slot_number
	var item = Inventory.items[item_index]
	var new_item = Inventory.items[new_index]
	var item_slot_type = get_parent().get_node("ItemSlot" + str(item_index)).get("slot_type")
	
	if item_index == new_index:
		pass	
	
	elif slot_type != 6 and can_equip_item(item) and item_matches_slot_type(item):
		if can_equip_item(new_item) and item_matches_slot_type(new_item):
			Inventory.unequip_item(new_item)
			Inventory.equip_item(item)
			Inventory.swap_items(item_index, new_index)
		if new_item == null:
			Inventory.equip_item(item)
			Inventory.swap_items(item_index, new_index)
	
	elif slot_type == 6 and can_equip_item(item):
		if can_equip_item(new_item) and item_slot_type == new_item.equipment_type:
			Inventory.unequip_item(item)
			Inventory.equip_item(new_item)
			Inventory.swap_items(new_index, item_index)
		elif new_item == null and item_slot_type == item.equipment_type:
			Inventory.unequip_item(item)
			Inventory.swap_items(new_index, item_index)
		else:
			Inventory.swap_items(new_index, item_index)
			
	elif new_item != null and item.name == new_item.name and item.get("stack_size") and slot_type == item_slot_type:
		if item.amount + new_item.amount <= item.stack_size:
			Inventory.change_item_quantity(new_index, item.amount)
			Inventory.remove_item(item_index)

		elif item.amount == item.stack_size or new_item.amount == new_item.stack_size:
			Inventory.swap_items(item_index, new_index)

		elif item.amount + new_item.amount >= item.stack_size:
			var value_to_add = new_item.stack_size - new_item.amount
			Inventory.change_item_quantity(new_index,  value_to_add)
			Inventory.change_item_quantity(item_index, -1 * (value_to_add))
	elif item_slot_type and slot_type == 6:
		Inventory.swap_items(new_index, item_index)
	else:
		pass

func _on_ItemSlot_gui_input(_event) -> void:
	"""
	kontrollerar om det sker en gui input ovanför itemslot
	(se till att noder ovanför skickar vidare input och inte tar upp den)
	"""
	if Inventory.items[slot_number] == null:
		return
	if Input.is_action_pressed("Drop"):
		if slot_type != 6:
			Inventory.unequip_item(Inventory.items[slot_number])
			Inventory.drop_item(slot_number)
		else:
			Inventory.drop_item(slot_number)
			
	if Input.is_action_pressed("ui_right_click") and Inventory.items[slot_number] is ConsumableItem and can_use_item:
		can_use_item = false
		Inventory.use_item(slot_number)
		yield(get_tree().create_timer(0.5), "timeout")
		can_use_item = true


func _on_ItemSlot_mouse_entered() -> void:
	"""
	om man håller över slot ska ett tooltip visas
	"""
	if Inventory.items[slot_number] != null:
		iteminfo.find_node("ItemNameLabel").text = Inventory.items[slot_number].name
		iteminfo.find_node("ItemDescriptionLabel").text = Inventory.items[slot_number].item_description


func _on_ItemSlot_mouse_exited() -> void:
	if Inventory.items[slot_number] != null:
		iteminfo.find_node("ItemNameLabel").text = ""
		iteminfo.find_node("ItemDescriptionLabel").text = ""
