extends Camera2D

onready var topLeft = $Node/TopLeft
onready var bottomRight = $Node/BottomRight


# Called when the node enters the scene tree for the first time.
func _ready():
	limit_top = topLeft.position.y
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
	limit_left = topLeft.position.x
