tool
extends Node

#############################################################
# NON PERSISTANT STATE
onready var score = StateInt.new(0)

#############################################################
# PERSISTANT STATE
func _ready():
	# Create (possibly load) level progress
	# Default value is false for each configured Level
	var levelProgress_default = {}
	for level_id in C.LEVELS.keys(): levelProgress_default[str(level_id)] = false
	PersistenceMngr.add_state("levelProgress", levelProgress_default)
	
	# Create (possibly load) settings
	PersistenceMngr.add_state("settingsAudio", C.DEFAULT_OPTIONS_AUDIO).connect("changed", self, "_on_settingsAudio_update")
	PersistenceMngr.add_state("settingsControls", C.DEFAULT_OPTIONS_KEYBINDINGS).connect("changed", self, "_on_settingsControls_update")
	# Inititally configure audio and controls
	_on_settingsAudio_update(PersistenceMngr.get_state("settingsAudio"))
	_on_settingsControls_update(PersistenceMngr.get_state("settingsControls"))

#############################################################
# HANDLERS FOR PERSISTENT STATE
func _on_settingsAudio_update(settingsAudio):
	for bus in settingsAudio.keys():
		var idx = AudioServer.get_bus_index(bus)
		if idx != -1:
			var vol = settingsAudio[bus]
			# 0 => -80, 100 => 0
			var db = -80 * (1 - (vol / 100.0))
			AudioServer.set_bus_volume_db(idx, db)
			
func _on_settingsControls_update(settingsControls):
	D.l("Controls", ["Configured Controls to be", settingsControls])
	for input_action in settingsControls.keys():
		var scancode = settingsControls[input_action]
		
		# Add this keybind in case it doesn't exist
		if !InputMap.has_action(input_action):
			InputMap.add_action(input_action)
			
		# Erase any already bound events from this input_action
		InputMap.action_erase_events(input_action)
		
		# Add new event to input_action if assigned scancode
		if scancode != null:
			var key_event = InputEventKey.new()
			key_event.set_scancode(scancode)
			InputMap.action_add_event(input_action, key_event)

#############################################################
# NOTITFYING State Object
class StateInt:
	signal state_changed(new_state)
	var state setget _set_state
	func _set_state(v):
		state = v
		emit_signal("state_changed", state)
	func _init(state):
		self.state = state
