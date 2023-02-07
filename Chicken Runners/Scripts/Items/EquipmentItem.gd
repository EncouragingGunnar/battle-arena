extends Item
class_name EquipmentItem

enum equipment_item_type {
	NECKLACE
	GEM
	GLOVE
	RING
	SCROLL
	SPELLBOOK
}

enum rarities {
	COMMON
	RARE
	EPIC
	LEGENDARY
}

export (rarities) var rarity
export (equipment_item_type) var equipment_type
export (int) var level_requirement
export (int) var melee_damage
export (int) var melee_attack_speed
export (int) var bow_damage
export (int) var bow_attack_speed
export (int) var defense
export (int) var max_health_increase
export (float) var knockback_resistance_increase
export (int) var knockback_strength_increase
export (int) var max_mana_increase

