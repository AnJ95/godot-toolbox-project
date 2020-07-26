extends Node

const JOYPAD_BUTTON = "JoypadButton"
const KEY = "Key"
const JOYPAD_MOTION = "JoypadMotion"
const MOUSE_BUTTON = "MouseButton"

const EVENT_TYPE_MAP = {
	InputEventJoypadButton : JOYPAD_BUTTON,
	InputEventKey : KEY,
	InputEventJoypadMotion : JOYPAD_MOTION,
	InputEventMouseButton : MOUSE_BUTTON
}

func _ready():
	set_input_map_from_settings(PersistenceMngr.get_state("settingsControls"))
	
func get_default_from_project_keybindings():
	var default = {}
	for action_name in InputMap.get_actions():
		default[action_name] = {}
		for event in InputMap.get_action_list(action_name):
			
			var event_type = __event_type_to_string_id(event)
			var event_info = null
			
			if event_type == JOYPAD_BUTTON:
				event_info = event.button_index
			if event_type == KEY:
				event_info = event.scancode
			if event_type == JOYPAD_MOTION:
				event_info = {"axis": event.axis, "axis_value" : event.axis_value}
			if event_type == MOUSE_BUTTON:
				event_info = event.button_index
			
			
			if event_type:
				default[action_name][event_type] = event_info
	return default

func __event_type_to_string_id(event:InputEvent):
	for event_type in EVENT_TYPE_MAP.keys():
		if event is event_type:
			return EVENT_TYPE_MAP[event_type]
	return null
	
func __string_id_to_event_instance(event_type:String, event_info):
	var inst = null
	
	# Create instance of right type
	for event_class in EVENT_TYPE_MAP.keys():
		if event_type == EVENT_TYPE_MAP[event_class]:
			inst = event_class.new()
	
	# Initialize with value
	if inst:
		match event_type:
			JOYPAD_BUTTON:
				inst.button_index = event_info
			KEY:
				inst.scancode = event_info
			JOYPAD_MOTION:
				inst.axis = event_info.axis
				inst.axis_value = event_info.axis_value
			MOUSE_BUTTON:
				inst.button_index = event_info
			
	return inst
	
func set_input_map_from_settings(settingsControls):
	D.l("Controls", ["Configured Controls to be", settingsControls])
	for action_name in settingsControls.keys():
		
		# Add this keybind in case it doesn't exist
		if !InputMap.has_action(action_name):
			InputMap.add_action(action_name)
		
		# Erase any already bound events from this action_name
		InputMap.action_erase_events(action_name)
		
		for event_type in settingsControls[action_name].keys():
			var input_event = __string_id_to_event_instance(event_type, settingsControls[action_name][event_type])
			InputMap.action_add_event(action_name, input_event)
		
