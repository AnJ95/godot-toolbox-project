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
# STATE
var valueOrPersistenceUIDPath

#############################################################
# LIFECYCLE
func init(caption, valueOrPersistenceUIDPath, value_min, value_max, value_step):
	if !label: label = $Label
	if !slider: slider = $HSlider
	
	label.text = caption
	self.valueOrPersistenceUIDPath = valueOrPersistenceUIDPath
	
	if _is_synced_with_persistence():
		slider.value = PersistenceManager.get_val_from_ui_path(valueOrPersistenceUIDPath)
	else:
		slider.value = int(valueOrPersistenceUIDPath)
	
	slider.min_value = int(value_min)
	slider.max_value = int(value_max)
	slider.step = int(value_step)
	return self

func _is_synced_with_persistence():
	return valueOrPersistenceUIDPath is String and not valueOrPersistenceUIDPath.is_valid_integer()
#############################################################
# CALLBACKS	
func _on_HSlider_value_changed(value):
	
	# Update PersistentObject if synced to it
	if _is_synced_with_persistence():
		PersistenceManager.set_val_from_ui_path(valueOrPersistenceUIDPath, value)
	
	emit_signal("slider_changed", slider.value)
