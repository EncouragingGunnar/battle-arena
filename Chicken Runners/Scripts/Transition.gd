extends CanvasLayer

onready var animationplayer = $AnimationPlayer

func load_scene(path) -> void:
	animationplayer.play("fade_in")
	yield(animationplayer, "animation_finished")
	get_tree().change_scene(path)
	animationplayer.play_backwards("fade_in")
