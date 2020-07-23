extends CanvasLayer

func _ready():
	if !C.USE_MOBILE_CONTROLS:
		queue_free()
