extends Button

export(String) var setting = "Fullscreen"

func _ready():

	pressed = PersistenceMngr.get_state("settingsVideo." + setting)
	
	# connect AFTERWARDS:
	connect("toggled", self, "_on_MenuToggleSettingButton_toggled")

func _on_MenuToggleSettingButton_toggled(button_pressed):
	PersistenceMngr.set_state("settingsVideo." + setting, button_pressed)
	
	
