extends Node2D

onready var mapnavigation = $MapNavigation
onready var knight = $Knights


func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	
	var new_path = mapnavigation.get_simple_path(knight.position(), get_global_mouse_position())	
	knight.position = new_path


