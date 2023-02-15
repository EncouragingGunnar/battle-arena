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
export (int) var melee_damage_increase
export (float) var melee_attack_speed_increase
export (int) var bow_damage_increase
export (float) var bow_attack_speed_increase
export (int) var defense_increase
export (int) var max_health_increase
export (float) var knockback_resistance_increase
export (int) var knockback_strength_increase
export (int) var max_mana_increase

