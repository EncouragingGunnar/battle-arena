extends PanelContainer

onready var itemtexture = $MarginContainer/ItemTexture


func display_item(item):
	if item:
		itemtexture.texture = item.texture
	else:
		itemtexture.texture = null

func get_drag_data(position):
	var item_index = get_index()
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
		
func can_drop_data(position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has("item")

func drop_data(position, data):
	var item_index = data.get("item_index")
	var new_index = get_index()
	Inventory.swap_items(new_index, item_index)

