extends TileMap

var delay = 0.6
onready var timer = $Timer
var region_x = 0
var size = 176 * 8

func _ready() -> void:
	timer.set_wait_time(delay)
	timer.start()

func _on_Timer_timeout() -> void:
	region_x += 176
	region_x %= size
	tile_set.tile_set_region(0, Rect2(region_x, 0.0, region_x + 176, 80))
	
