extends Node2D

onready var menu = $MenuLayer/MarginContainer/HBoxContainer/VBoxContainer/Menu

#############################################################
# LIFECYCLE
func _ready():
	menu.connect("button_pressed", self, "_on_button_pressed")

#############################################################
# CALLBACKS
func _on_button_pressed(button_name):
	match button_name:
		"video":
			ScrnMngr.push_screen(C.Screen.OPTIONS_VIDEO_MENU)
		"audio":
			ScrnMngr.push_screen(C.Screen.OPTIONS_AUDIO_MENU)
		"controls":
			ScrnMngr.push_screen(C.Screen.OPTIONS_CONTROLS_MENU)
		"about":
			ScrnMngr.push_screen(C.Screen.ABOUT)
		"back":
			ScrnMngr.pop_screen()
		_:
			D.l(D.LogCategory.MENU, ["No handler specified for Button [Name:", button_name, "]"], D.LogLevel.ERROR)
