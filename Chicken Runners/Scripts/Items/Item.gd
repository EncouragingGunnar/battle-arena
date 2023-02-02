extends Resource
class_name Item

enum item_type {
	EQUIPMENT
	CONSUMABLE
	MATERIAL
}

export (String) var name = ""
export (String, MULTILINE) var item_description
export (Texture) var texture
export (item_type) var itemtype
