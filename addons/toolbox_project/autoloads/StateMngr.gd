tool
extends Node

#############################################################
# NON PERSISTENT STATE
onready var score = ModelInt.new(0)
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
	PersistenceMngr.add_state("settingsAudio", C.DEFAULT_OPTIONS_AUDIO).connect("changed", SoundMngr, "_on_settingsAudio_update")
	PersistenceMngr.add_state("settingsControls", ControlMngr.get_default_from_project_keybindings().duplicate(true)).connect("changed", ControlMngr, "set_input_map_from_settings")
	
	
	# Inititally configure options
	_on_settingsVideo_update(PersistenceMngr.get_state("settingsVideo"))
	SoundMngr._on_settingsAudio_update(PersistenceMngr.get_state("settingsAudio"))

#############################################################
# HANDLERS FOR PERSISTENT STATE
func _on_settingsVideo_update(settingsVideo):
	OS.window_fullscreen = settingsVideo["Fullscreen"]
	OS.vsync_enabled = settingsVideo["VSync"]
		

#############################################################
# NOTITFYING State Object
class ModelInt:
	signal state_changed(new_state)
	var state setget _set_state
	func _set_state(v):
		state = v
		emit_signal("state_changed", state)
	func _init(state):
		self.state = state
