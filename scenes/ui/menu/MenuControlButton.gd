tool
extends HBoxContainer

#############################################################
# SIGNALS
signal control_changed(scan_code)

#############################################################
# NODES
onready var label = $Label
onready var button = $Button

#############################################################
# CUSTOMIZATION
export(String) var caption = "None"
export(String) var persistence_uid_path = "none"
export(String) var input_action_name = "none"

#############################################################
# STATE
var scancode

#############################################################
# LIFECYCLE
func _ready():
	scancode = PersistenceManager.get_val_from_ui_path(persistence_uid_path)
	
	label.text = caption
	button.text = OS.get_scancode_string(scancode)
	
	return self

#############################################################
# CALLBACKS	

