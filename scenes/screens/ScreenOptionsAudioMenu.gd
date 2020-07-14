extends Node2D

onready var menu = $MenuLayer/MarginContainer/HBoxContainer/VBoxContainer/Menu

#############################################################
# LIFECYCLE
func _ready():
	menu.connect("button_pressed", self, "_on_button_pressed")
	menu.connect("slider_changed", self, "_on_slider_changed")

#############################################################
# CALLBACKS
func _on_button_pressed(button_name):
	match button_name:
		"back":
			ScrnMngr.pop_screen()
		_:
			D.l(D.LogCategory.MENU, ["No handler specified for Button [Name:", button_name, "]"], D.LogLevel.ERROR)

func _on_slider_changed(slider_name, value):
	match slider_name:
		"volumeMaster":
			G.volume.Master = value
		"volumeMusic":
			G.volume.Music = value
		"volumeEffects":
			G.volume.Effects = value
		_:
			D.l(D.LogCategory.MENU, ["No handler specified for Slider [Name:", slider_name, "]"], D.LogLevel.ERROR)
