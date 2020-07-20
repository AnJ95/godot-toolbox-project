extends Camera2D

enum CameraType {
	Static
	StaticLevel
	StaticLevelZoomCover,
	StaticLevelZoomFill,
	Player
}
export(CameraType) var camera_type = CameraType.Player

func _ready():
	SignalMngr.connect("level_started", self, "_on_level_started")

func _on_level_started(level):
	
	# Check if this camera is required
	current = level.camera_type == camera_type
	
	# Only do this with the right camera type
	if level.camera_type == camera_type:

		if camera_type == CameraType.Static:
			position = level.camera_position
			zoom = level.camera_zoom
		
		if camera_type == CameraType.Player:
			zoom = level.camera_zoom
		
		var rect:Rect2 = level.get_map_rect()
		
		if camera_type == CameraType.StaticLevel:
			position = rect.position + rect.size / 2
			zoom = level.camera_zoom
			
		if camera_type in [CameraType.StaticLevelZoomCover, CameraType.StaticLevelZoomFill]:
			position = rect.position + rect.size / 2
			zoom = rect.size / get_viewport_rect().size
			
			if camera_type == CameraType.StaticLevelZoomCover:
				if zoom.x > zoom.y: zoom.y = zoom.x
				if zoom.y > zoom.x: zoom.x = zoom.y

