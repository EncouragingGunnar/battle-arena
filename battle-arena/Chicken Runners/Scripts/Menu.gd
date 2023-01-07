extends Control

func _ready():
	$VBoxContainer/StartButton.grab_focus()


func _on_StartButton_pressed():
	Transition.load_scene("res://Scenes/Level.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
