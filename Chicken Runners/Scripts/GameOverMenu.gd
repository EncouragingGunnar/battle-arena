extends Control

onready var coinslabel = $CoinsLabel

func _ready():
	coinslabel.text = "You collected " + str(Globals.coins) + " Coins!"
	

func _on_MenuButton_pressed() -> void:
	Transition.load_scene("res://Scenes/Menus/Menu.tscn")
	Globals.coins = 0
