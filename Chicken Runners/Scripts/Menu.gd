extends Control

func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()


func _on_StartButton_pressed() -> void:
	Transition.load_scene("res://Scenes/Forest.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_StartButton2_pressed():
	Transition.load_scene("res://Scenes/Dungeon.tscn")

