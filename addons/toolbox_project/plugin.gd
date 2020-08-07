tool
extends EditorPlugin

const AUTOLOADS_PATH = C.BASE_PATH + "autoloads/"

const autoloads = {
	"C":				C.BASE_PATH + "Config.gd",
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
	

func _exit_tree():
	for key in autoloads.keys():
		remove_autoload_singleton(key)
