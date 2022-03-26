tool
extends HBoxContainer

#############################################################
# SIGNALS
signal control_changed(scan_code)

#############################################################
# NODES
onready var button = $Button

#############################################################
# CUSTOMIZATION

# Determines wether to put initial focus on this button
export(bool) var grabs_focus = false

#############################################################
# STATE
var persistence_uid_path
var awaiting = false

var action_name
var event_i
var event_info

#############################################################
# LIFECYCLE
func init(action_name, event_i):
	self.action_name = action_name
	self.event_i = event_i
	
func _ready():
	if action_name and event_i != null:
		persistence_uid_path = "settingsControls." + action_name + "." + str(event_i)
		event_info = PersistenceMngr.get_state(persistence_uid_path)
		button.text = get_display_caption()
	else:
		button.text = "Uninit ControlMenuButton"
	#if grabs_focus:
	#	button.grab_focus()

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
func set_event(event_info):
	
	self.event_info = event_info
	
	# Update PersistentObj
	PersistenceMngr.set_state(persistence_uid_path, event_info)
	
	# Unassign all other that have the same key
	if event_info != null:
		for control_button in get_all_menu_control_buttons():
			if control_button != self and ControlMngr.__event_infos_equal(event_info, control_button.event_info):
				control_button.set_event(null)
	
	# Update button text
	button.text = get_display_caption()
	
func get_display_caption():
	if event_info != null:
		var input_event:InputEvent = ControlMngr.__event_info_to_instance(event_info)
		var caption = ControlMngr.get_pretty_string(event_info)
		if caption != "":
			return caption
	return "<Unassigned>"

func grab_focus():
	button.grab_focus()

func get_all_menu_control_buttons():
	return get_tree().get_nodes_in_group("MenuControlButton")

#############################################################
# CALLBACKS	
func _on_Button_pressed():
	SoundMngr.play_ui_sound(C.UI_SELECT)
	if button.pressed:
		start_awaiting()
	else:
		end_awaiting()

func _input(event):
	if awaiting:
		var event_info = ControlMngr.__event_instance_to_event_info(event)
		if event_info:
			accept_event()
			set_event(event_info)
			end_awaiting()
			return true
