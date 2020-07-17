extends ParallaxBackground

func _ready():
	Sgn.connect("level_started", self, "_on_level_started")

func _on_level_started(level:Node):
	
	if get_parent() == level:
		show()
	else:
		hide()
		
	var i = 0
	for l in get_children():
		var layer:ParallaxLayer = l
		var sprite:Sprite = layer.get_children()[0]
		
		layer.motion_scale.y = 0
		layer.motion_scale.x = i * 0.1
		
		var sw = sprite.texture.get_width()
		var sh = sprite.texture.get_height()
		
		sprite.region_enabled = true
		sprite.region_rect = Rect2(-2*sw, 0, 4*sw, sh)
		
		sprite.centered = true
		sprite.scale = get_viewport().get_visible_rect().size / Vector2(sw, sh)
		
		i += 1

func show():
	for l in get_children():
		l.get_children()[0].show()
func hide():
	for l in get_children():
		l.get_children()[0].hide()
