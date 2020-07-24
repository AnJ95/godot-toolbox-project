extends "res://scenes/screens/Screen.gd"


onready var btn_video = $MenuLayer/UIBox/VBoxContainer/Menu/BtnVideo
onready var btn_audio = $MenuLayer/UIBox/VBoxContainer/Menu/BtnAudio
onready var btn_controls = $MenuLayer/UIBox/VBoxContainer/Menu/BtnControls

func _ready():
	if !C.SHOW_SETTINGS_VIDEO:
		btn_video.hide()
	if !C.SHOW_SETTINGS_AUDIO:
		btn_audio.hide()
	if !C.SHOW_SETTINGS_KEYBINDINGS:
		btn_controls.hide()
