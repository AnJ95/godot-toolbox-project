extends Node2D

onready var ref_rect:ReferenceRect = $ReferenceRect

func _ready():
	add_to_group("TileMapDemo")
	
func get_map_rect()->Rect2:
	var rect_pos = ref_rect.rect_global_position
	var rect_size = ref_rect.rect_size
	return Rect2(rect_pos, rect_size)
