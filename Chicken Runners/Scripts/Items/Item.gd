extends Resource
class_name Item

enum item_type {
	CONSUMABLE
	MATERIAL
	RING
	GLOVE
	GEM
	SCROLL
	SPELLBOOK
	NECKLACE
}

export (String) var name = ""
export (String, MULTILINE) var item_description
export (Texture) var texture
export (int) var amount
export (int) var stack_size
export (item_type) var itemtype
