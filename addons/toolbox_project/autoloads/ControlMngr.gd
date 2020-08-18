tool
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

const MOUSE_BUTTON_STRINGS = {
	BUTTON_LEFT : "Mouse Left",
	BUTTON_RIGHT : "Mouse Right",
	BUTTON_MIDDLE : "Mouse Middle",
	BUTTON_XBUTTON1 : "Mouse X1",
	BUTTON_XBUTTON2 : "Mouse X2",
	BUTTON_WHEEL_UP : "Mouse Wheel Up",
	BUTTON_WHEEL_DOWN : "Mouse Wheel Down",
	BUTTON_WHEEL_LEFT : "Mouse Wheel Left",
	BUTTON_WHEEL_RIGHT : "Mouse Wheel Right"
}

func _ready():
	set_input_map_from_settings(PersistenceMngr.get_state("settingsControls"))
	
func get_default_from_project_keybindings():
	var default = {}
	
	# Loads even when tool
	InputMap.load_from_globals()
	
	for action_name in InputMap.get_actions():
		default[action_name] = []
		for event in InputMap.get_action_list(action_name):
			var event_info = __event_instance_to_event_info(event)
			default[action_name].append(event_info)
	return default

func __event_instance_to_event_info(event:InputEvent):
	var result = {}
	result.type = __event_instance_to_type_string(event)
	
	if result.type == null:
		return null
	
	match result.type:
		JOYPAD_BUTTON:
			result.button_index = event.button_index
		KEY:
			result.scancode = event.scancode
		JOYPAD_MOTION:
			result.axis = event.axis
			result.axis_value = 1 if event.axis_value > 0 else -1
		MOUSE_BUTTON:
			result.button_index = event.button_index
	
	return result
	
func __event_infos_equal(a, b)->bool:
	# both null
	if a == null and b == null: return true
	# only one null
	if a == null or b == null: return false
	# check size
	if a.size() != b.size(): return false
	# check if b has everything a has
	for i in a.keys():
		if !b.has(i) or a[i] != b[i]:
			return false
	return true

func __event_instance_to_type_string(event:InputEvent):
	for event_type in EVENT_TYPE_MAP.keys():
		if event is event_type:
			return EVENT_TYPE_MAP[event_type]
	return null
	
func __event_info_to_instance(event_info):
	var inst = null
	
	# Create instance of right type
	for event_class in EVENT_TYPE_MAP.keys():
		if event_info.type == EVENT_TYPE_MAP[event_class]:
			inst = event_class.new()
	
	# Initialize with value
	if inst:
		match event_info.type:
			JOYPAD_BUTTON:
				if !event_info.button_index is int and !event_info.button_index is float and !event_info.button_index.is_valid_integer():
					D.e("ControlMngr", ["Error parsing button_index of control bindings settings", event_info])
					return null
				inst.button_index = int(event_info.button_index)
			KEY:
				if !event_info.scancode is int and !event_info.scancode is float and !event_info.button_index.is_valid_integer():
					D.e("ControlMngr", ["Error parsing scancode of control bindings settings", event_info])
					return null
				inst.scancode = int(event_info.scancode)
			JOYPAD_MOTION:
				if !event_info.axis is int and !event_info.axis is float and !event_info.axis.is_valid_integer():
					D.e("ControlMngr", ["Error parsing axis of control bindings settings", event_info])
					return null
				if !event_info.axis_value is int and !event_info.axis_value is float and !event_info.axis_value.is_valid_float():
					D.e("ControlMngr", ["Error parsing axis_value of control bindings settings", event_info])
					return null
				inst.axis = int(event_info.axis)
				inst.axis_value = 1 if float(event_info.axis_value) > 0 else -1
			MOUSE_BUTTON:
				if !event_info.button_index is int and !event_info.button_index is float and !event_info.axis_value.is_valid_float():
					D.e("ControlMngr", ["Error parsing button_index of control bindings settings", event_info])
					return null
				inst.button_index = int(event_info.button_index)
			
	return inst
	
func get_pretty_string(event_info)->String:
	match event_info.type:
		JOYPAD_BUTTON:
			return Input.get_joy_button_string(event_info.button_index)
		KEY:
			return OS.get_scancode_string(event_info.scancode)
		JOYPAD_MOTION:
			var pretty:String = Input.get_joy_axis_string(event_info.axis)
			pretty = pretty.replace("X", "Right" if event_info.axis_value > 0 else "Left")
			pretty = pretty.replace("Y", "Down" if event_info.axis_value > 0 else "Up")
			return pretty
		MOUSE_BUTTON:
			return MOUSE_BUTTON_STRINGS[int(event_info.button_index)] if MOUSE_BUTTON_STRINGS.has(int(event_info.button_index)) else ""
	return ""
	
func set_input_map_from_settings(settingsControls):
	for action_name in settingsControls.keys():
		
		# Add this keybind in case it doesn't exist
		if !InputMap.has_action(action_name):
			InputMap.add_action(action_name)
		
		# Erase any already bound events from this action_name
		InputMap.action_erase_events(action_name)
		
		for event_info in settingsControls[action_name]:
			if event_info == null:
				continue
			var input_event = __event_info_to_instance(event_info)
			InputMap.action_add_event(action_name, input_event)
		
