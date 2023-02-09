extends Control

func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()


func _on_StartButton_pressed() -> void:
	Transition.load_scene("res://Scenes/Level.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
