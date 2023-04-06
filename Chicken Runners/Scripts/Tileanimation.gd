extends TileMap

var timer: Timer

export (float) var delay = 0.6
var region_x: int = 0
export (int) var total_size 
export (int) var region_size
export (int) var height

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout",self ,  "_on_Timer_timeout")
	timer.set_wait_time(delay)
	timer.set_one_shot(false)
	timer.start()

func _on_Timer_timeout() -> void:
	region_x += region_size
	region_x %= total_size
	tile_set.tile_set_region(0, Rect2(region_x, 0.0, region_x + region_size, height))


