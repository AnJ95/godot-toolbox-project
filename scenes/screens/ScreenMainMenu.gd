extends Node2D

onready var btn_start = $MenuLayer/UIBox/VBoxContainer/Menu/BtnStart
onready var btn_settings = $MenuLayer/UIBox/VBoxContainer/Menu/BtnSettings

func _ready():
	if C.SHOW_LEVEL_MENU:
		btn_start.screen_to_switch_to = C.Screen.LEVEL_MENU
	
	if !C.SHOW_SETTINGS:
		btn_settings.hide()
