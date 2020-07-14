extends Node2D

onready var menu = $MenuLayer/MarginContainer/HBoxContainer/VBoxContainer/Menu

func _ready():
	menu.connect("button_pressed", self, "_on_button_pressed")

func _on_button_pressed(button_name):
	match button_name:
		"gameStart":
			ScrnMngr.push_screen(C.Screen.GAME)
		"options":
			ScrnMngr.push_screen(C.Screen.OPTIONS_MENU)
		"gameQuit":
			get_tree().quit()
