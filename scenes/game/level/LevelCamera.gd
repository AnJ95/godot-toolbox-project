extends Camera2D

enum CameraType {
	Static,
	StaticZoomed,
	FollowPlayerZoomed
	FollowPlayer
}
export(CameraType) var camera_type = CameraType.FollowPlayerZoomed

func _ready():
	SignalMngr.connect("level_started", self, "_on_level_started")

func _on_level_started(level):
	
	# Check if this camera is required
	current = level.camera_type == camera_type
	
	# Only do this with the right camera type
	if level.camera_type == camera_type:
		print("Activating Camera", CameraType.keys()[camera_type])
		var rect:Rect2 = level.get_map_rect()
		
		# if zooming: calc zoom level
		if camera_type in [CameraType.StaticZoomed, CameraType.FollowPlayerZoomed]:
			zoom = rect.size / get_viewport_rect().size
			if zoom.x > zoom.y: zoom.y = zoom.x
			if zoom.y > zoom.x: zoom.x = zoom.y
		
		# if static camera: set position
		if camera_type in [CameraType.StaticZoomed, CameraType.Static]:
			offset = rect.position + rect.size / 2
	

