tool
extends CanvasLayer

func _ready():
	if !Engine.editor_hint and !C.USE_MOBILE_CONTROLS:
		queue_free()
