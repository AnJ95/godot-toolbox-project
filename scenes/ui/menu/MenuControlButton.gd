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

# Determines wether to put initial focus on this button
export(bool) var grabs_focus = false

#############################################################
# STATE
var scancode
var awaiting = false

#############################################################
# LIFECYCLE
func _ready():
	scancode = PersistenceManager.get_val_from_ui_path(persistence_uid_path)
	
	label.text = caption
	button.text = OS.get_scancode_string(scancode)
	
	if grabs_focus:
		button.grab_focus()

#############################################################
# AWAITING CONDITION
func start_awaiting():
	for control_button in get_all_menu_control_buttons():
		control_button.end_awaiting()
	button.pressed = true
	awaiting = true
	button.text = "<Enter Key>"
	
func end_awaiting():
	awaiting = false
	button.pressed = false
	button.text = get_display_caption()

#############################################################
# GETTERS & SETTERS
func set_scan_code(new_scancode):
	# Set locally
	scancode = new_scancode
	
	# Update PersistentObj
	PersistenceManager.set_val_from_ui_path(persistence_uid_path, scancode)
	
	# Unassign all other that have the same key
	for control_button in get_all_menu_control_buttons():
		if control_button != self and control_button.scancode == scancode:
			control_button.set_scan_code(null)
	
	# Update button text
	button.text = get_display_caption()
	
func get_display_caption():
	if scancode:
		return OS.get_scancode_string(scancode)
	else:
		return "Unassigned"

func get_all_menu_control_buttons():
	return get_tree().get_nodes_in_group("MenuControlButton")
	 
#############################################################
# CALLBACKS	
func _on_Button_pressed():
	if button.pressed:
		start_awaiting()
	else:
		end_awaiting()

func _input(event):
	if awaiting and event is InputEventKey:
		var event_key:InputEventKey = event
		if event_key.pressed:
			set_scan_code(event_key.scancode)
			end_awaiting()
