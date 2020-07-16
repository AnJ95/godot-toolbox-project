extends Camera2D

func _ready():
	Sgn.connect("level_started", self, "_on_level_started")

func _on_level_started(demo):
	var rect = demo.get_map_rect()
	# Adjust Camera
	zoom = rect.size / get_viewport_rect().size
	if zoom.x > zoom.y: zoom.y = zoom.x
	if zoom.y > zoom.x: zoom.x = zoom.y
	offset = rect.position + rect.size / 2
