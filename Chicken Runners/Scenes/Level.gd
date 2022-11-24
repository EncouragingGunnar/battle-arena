extends Node2D

onready var mapnavigation = $MapNavigation
onready var knight = $Knights

func _ready() -> void:
	pass

var new_path = mapnavigation.get_simple_path(knight.position,get_global_mouse_position())	

	

