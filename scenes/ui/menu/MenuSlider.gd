tool
extends HBoxContainer

#############################################################
# SIGNALS
signal slider_changed(value)

#############################################################
# NODES
onready var label:Label = $Label
onready var slider:HSlider = $HSlider

#############################################################
# LIFECYCLE
func init(caption, value, value_min, value_max, value_step):
	if !label: label = $Label
	if !slider: slider = $HSlider
	
	label.text = caption
	
	slider.value = int(value)
	slider.min_value = int(value_min)
	slider.max_value = int(value_max)
	slider.step = int(value_step)
	return self

#############################################################
# CALLBACKS	
func _on_HSlider_value_changed(value):
	emit_signal("slider_changed", slider.value)
