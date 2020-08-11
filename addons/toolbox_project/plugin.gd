tool
extends EditorPlugin

const BASE_PATH = "res://addons/toolbox_project/"
const AUTOLOADS_PATH = BASE_PATH + "autoloads/"



const Dock = preload("res://addons/toolbox_project/dock/Dock.tscn")
var dock



const autoloads = {
	"C":				BASE_PATH + "Config.gd",
	"D":				AUTOLOADS_PATH + "Debug.gd",
	"ScreenMngr":		AUTOLOADS_PATH + "ScreenMngr.gd",
	"StateMngr":		AUTOLOADS_PATH + "StateMngr.gd",
	"SignalMngr":		AUTOLOADS_PATH + "SignalMngr.gd",
	"PersistenceMngr":AUTOLOADS_PATH + "PersistenceMngr.gd",
	"SoundMngr":		AUTOLOADS_PATH + "SoundMngr.gd",
	"ControlMngr":	AUTOLOADS_PATH + "ControlMngr.gd"
}



func _enter_tree():
	
	
	for key in autoloads.keys():
		add_autoload_singleton(key, autoloads[key])

	# Add the loaded scene to the docks.
	dock = create_dock()
	add_control_to_bottom_panel(dock, "ToolboxProject")
	
	# Print Getting Started
	print(get_description())

func create_dock():
	var dock = Dock.instance()
	dock.ei = get_editor_interface()
	dock.gui = get_editor_interface().get_base_control()
	return dock

	
#func get_plugin_icon():
	#return Icon

func _exit_tree():
	for key in autoloads.keys():
		remove_autoload_singleton(key)

	remove_control_from_bottom_panel(dock)
	dock.queue_free()

var timer = 0
func _process(delta):
	timer += delta
	if timer > 5:
		timer = 0
		dock.update_ui()

func get_description():
	var d = ""
	d += "##########################################\n"
	d += "## TOOLBOX PROJECT                      ##\n"
	d += "##########################################\n"

	d += "# Getting started\n"
	d += "## ToolboxProject bottom control \n"
	d += "The easiest way to get started is to use the panel found at the bottom of the editor, labeled \"ToolboxProject\".\n"
	d += ""

	d += "## Add a config file\n"

	d += "Checklist\n"

	d += "##########################################\n"
	return d;
