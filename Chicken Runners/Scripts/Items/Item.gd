extends Resource
class_name Item

enum item_type {
	NECKLACE
	GEM
	GLOVE
	RING
	SCROLL
	SPELLBOOK
	CONSUMABLE
	MATERIAL
}

export (String) var name = ""
export (String, MULTILINE) var item_description
export (Texture) var texture
export (int) var amount
export (int) var stack_size
export (item_type) var itemtype
