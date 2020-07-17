extends Camera2D

enum CameraType {
	StaticZoomed,
	FollowPlayerZoomed
}
export(CameraType) var camera_type = CameraType.FollowPlayerZoomed

func _ready():
	Sgn.connect("level_started", self, "_on_level_started")

func _on_level_started(level):
	
	# Check if this camera is required
	current = level.camera_type == camera_type
	
	# Adjust Camera Settings
	if camera_type == CameraType.StaticZoomed:
		var rect = level.get_map_rect()
		
		zoom = rect.size / get_viewport_rect().size
		if zoom.x > zoom.y: zoom.y = zoom.x
		if zoom.y > zoom.x: zoom.x = zoom.y

		offset = rect.position + rect.size / 2
	

