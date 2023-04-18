extends CanvasLayer

onready var animationplayer = $AnimationPlayer

func load_scene(path) -> void:
	"""
	tar in en filepath till en scen
	spelar animation och byter scen till den nya scenen
	spelar animation
	"""
	animationplayer.play("fade_in")
	yield(animationplayer, "animation_finished")
	get_tree().change_scene(path)
	animationplayer.play_backwards("fade_in")
