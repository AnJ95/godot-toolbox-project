tool
extends HBoxContainer

export var has_halfes = true
export var value_now = 2.5
export var value_max = 5

export(Texture) var texture

var region_width
var region_height

func _ready():
	region_width = texture.get_width() / 3
	region_height = texture.get_height()
	
	init_value()
	update_value()

func init_value():
	for icon in get_children():
		icon.queue_free()
	
	for i in range(value_max):
		var atlas:AtlasTexture = AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(2 * region_width, 0, region_width, region_height)
		
		var icon:TextureRect = TextureRect.new()
		#icon.expand = true
		icon.stretch_mode = icon.STRETCH_KEEP_ASPECT_CENTERED
		icon.size_flags_vertical = icon.SIZE_EXPAND_FILL
		icon.size_flags_horizontal = icon.SIZE_EXPAND
		icon.anchor_right = 1
		icon.anchor_bottom = 1

		icon.texture = atlas
		add_child(icon)

func update_value():
	var value_left = value_now

	for icon in get_children():
		
		var region_id = 2
		if value_left >= 1:
			value_left -= 1
			region_id = 0
		elif has_halfes and value_left >= 0.5:
			value_left -= 0.5
			region_id = 1
			
		icon.texture.region.position.x = region_id * region_width
		
