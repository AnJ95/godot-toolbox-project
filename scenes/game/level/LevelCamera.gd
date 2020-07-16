extends Camera2D

export var zoom_to_level = true
export var offset_to_level = true

func _ready():
	Sgn.connect("level_started", self, "_on_level_started")

func _on_level_started(level):
	var rect = level.get_map_rect()
	# Adjust Camera
	if zoom_to_level:
		zoom = rect.size / get_viewport_rect().size
		if zoom.x > zoom.y: zoom.y = zoom.x
		if zoom.y > zoom.x: zoom.x = zoom.y
		
	if offset_to_level:
		offset = rect.position + rect.size / 2
	else:
		offset = Vector2()
