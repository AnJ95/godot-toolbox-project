extends ParallaxBackground

func _ready():
	var i = 0
	for l in get_children():
		var layer:ParallaxLayer = l
		var sprite:Sprite = layer.get_children()[0]
		
		layer.motion_scale.y = 0
		layer.motion_scale.x = (i+1) * 0.12
		
		var sw = sprite.texture.get_width()
		var sh = sprite.texture.get_height()
		
		sprite.region_enabled = true
		sprite.region_rect = Rect2(-2*sw, 0, 4*sw, sh)
		
		sprite.centered = true
		sprite.scale = get_viewport().get_visible_rect().size / Vector2(sw, sh)
		
		i += 1
