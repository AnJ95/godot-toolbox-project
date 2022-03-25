tool
extends Control

#############################################################
# CONSTANTS
enum Corner {
	TopLeft, TopRight, BottomLeft, BottomRight
}

#############################################################
# CUSTOMIZATION
export var margin = 20 setget _set_margin
export var size_outer = 200 setget _set_size_outer
export(Corner) var anchor_corner = Corner.BottomLeft setget _set_anchor_corner

#############################################################
# SETTERS
func _set_margin(v):
	margin = v
	relayout()
func _set_size_outer(v):
	size_outer = v;
	relayout()
func _set_anchor_corner(v):
	anchor_corner = v
	relayout()

#############################################################
# STATE
onready var _cache_half_size = size_outer / 2
var is_dragging = -1

#############################################################
# LIFECYLE
func relayout():
	var is_left = anchor_corner in [Corner.TopLeft, Corner.BottomLeft]
	anchor_left = 0 if is_left else 1
	anchor_right = 0 if is_left else 1
	margin_left = margin if is_left else -margin-size_outer
	margin_right = margin+size_outer if is_left else -margin
	
	var is_top = anchor_corner in [Corner.TopLeft, Corner.TopRight]
	anchor_top = 0 if is_top else 1
	anchor_bottom = 0 if is_top else 1
	margin_top = margin if is_top else -margin-size_outer
	margin_bottom = margin+size_outer if is_top else -margin

func _ready():
	relayout()
	
func is_global_pos_in_control(pos:Vector2):
	return get_global_rect().has_point(pos)
	
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed and is_global_pos_in_control(event.position):
			is_dragging = event.index
			_on_touch()
		elif !event.pressed and is_dragging == event.index:
			is_dragging = -1
			_on_untouch()
	if event is InputEventScreenDrag:
		if is_dragging == event.index:
			_on_touch_move(event.position)

func _on_touch():
	pass

func _on_untouch():
	pass

func _on_touch_move(global_pos:Vector2):
	pass
