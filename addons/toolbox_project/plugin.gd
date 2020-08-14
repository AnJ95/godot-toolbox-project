tool
extends EditorPlugin

const BASE_PATH = "res://addons/toolbox_project/"
const AUTOLOADS_PATH = BASE_PATH + "autoloads/"



const Dock = preload("res://addons/toolbox_project/dock/Dock.tscn")
var dock



const autoloads = {
	"C":				AUTOLOADS_PATH + "Config.gd",
	"D":				AUTOLOADS_PATH + "Debug.gd",
	"ScreenMngr":		AUTOLOADS_PATH + "ScreenMngr.gd",
	"StateMngr":		AUTOLOADS_PATH + "StateMngr.gd",
	"SignalMngr":		AUTOLOADS_PATH + "SignalMngr.gd",
	"PersistenceMngr":AUTOLOADS_PATH + "PersistenceMngr.gd",
	"SoundMngr":		AUTOLOADS_PATH + "SoundMngr.gd",
	"ControlMngr":	AUTOLOADS_PATH + "ControlMngr.gd"
}



func _enter_tree():
	# Print Getting Started
	print(get_description())
	
	for key in autoloads.keys():
		add_autoload_singleton(key, autoloads[key])

	# Add the loaded scene to the docks.
	dock = create_dock()
	add_control_to_bottom_panel(dock, "ToolboxProject")


func create_dock():
	var dock = Dock.instance()
	dock.plugin = self
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

	d += "If this is the first time you added the addon, you may be getting a lot of errors.\n"
	d += "Just reopen the project and use the ToolboxProject widget at the bottom of the editor to configure your project!\n"
	

	d += "##########################################\n"
	return d;
