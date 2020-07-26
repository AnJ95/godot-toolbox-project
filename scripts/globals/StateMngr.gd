tool
extends Node

#############################################################
# NON PERSISTENT STATE
onready var score = StateInt.new(0)
onready var default_options_controls = ControlMngr.get_default_from_project_keybindings()
var start_level_id = -1

#############################################################
# PERSISTENT STATE
func _ready():
	# Create (possibly load) level progress
	# Default value is false for each configured Level
	var levelProgress_default = {}
	for level_id in C.LEVELS.keys():
		levelProgress_default[str(level_id)] = C.UNLOCK_ALL_LEVELS
	PersistenceMngr.add_state("levelProgress", levelProgress_default)
	
	# Create (possibly load) settings
	PersistenceMngr.add_state("settingsVideo", C.DEFAULT_OPTIONS_VIDEO).connect("changed", self, "_on_settingsVideo_update")
	PersistenceMngr.add_state("settingsAudio", C.DEFAULT_OPTIONS_AUDIO).connect("changed", self, "_on_settingsAudio_update")
	PersistenceMngr.add_state("settingsControls", default_options_controls.duplicate(true)).connect("changed", ControlMngr, "set_input_map_from_settings")
	
	
	# Inititally configure options
	_on_settingsAudio_update(PersistenceMngr.get_state("settingsVideo"))
	_on_settingsAudio_update(PersistenceMngr.get_state("settingsAudio"))

#############################################################
# HANDLERS FOR PERSISTENT STATE
func _on_settingsVideo_update(settingsVideo):
	OS.window_fullscreen = settingsVideo["Fullscreen"]
	OS.vsync_enabled = settingsVideo["VSync"]
		
			
func _on_settingsAudio_update(settingsAudio):
	for bus in settingsAudio.keys():
		var idx = AudioServer.get_bus_index(bus)
		if idx != -1:
			var vol = settingsAudio[bus]
			# 0 => -80, 100 => 0
			var db = -80 * (1 - (vol / 100.0))
			AudioServer.set_bus_volume_db(idx, db)

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
