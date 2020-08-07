tool
extends EditorPlugin

const BASE_PATH = "res://addons/toolbox_project/autoloads/"

const autoloads = {
	"C":			BASE_PATH + "Config.gd",
	"D":			BASE_PATH + "Debug.gd",
	"ScreenMngr":			BASE_PATH + "ScreenMngr.gd",
	"StateMngr":			BASE_PATH + "StateMngr.gd",
	"SignalMngr":			BASE_PATH + "SignalMngr.gd",
	"PersistenceMngr":			BASE_PATH + "PersistenceMngr.gd",
	"SoundMngr":			BASE_PATH + "SoundMngr.gd",
	"ControlMngr":			BASE_PATH + "ControlMngr.gd"
}

func _enter_tree():
	for key in autoloads.keys():
		add_autoload_singleton(key, autoloads[key])


func _exit_tree():
	for key in autoloads.keys():
		remove_autoload_singleton(key)
