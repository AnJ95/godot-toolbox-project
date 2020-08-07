tool
extends Button

export(bool) var grabs_focus = false
export(String) var setting = "Fullscreen"

func _ready():

	pressed = PersistenceMngr.get_state("settingsVideo." + setting)
	
	# connect AFTERWARDS:
	connect("toggled", self, "_on_MenuToggleSettingButton_toggled")

func _enter_tree():
	if grabs_focus:
		grab_focus()

func _on_MenuToggleSettingButton_toggled(button_pressed):
	SoundMngr.play_ui_sound(C.UI_SELECT)
	PersistenceMngr.set_state("settingsVideo." + setting, button_pressed)
	
	
