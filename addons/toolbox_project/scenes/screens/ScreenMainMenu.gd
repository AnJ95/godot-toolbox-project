extends Screen

onready var btn_start = $MenuLayer/UIBox/VBoxContainer/PanelContainer/Menu/BtnStart
onready var btn_settings = $MenuLayer/UIBox/VBoxContainer/PanelContainer/Menu/BtnSettings

func _ready():
	if C.SHOW_LEVEL_MENU:
		btn_start.screen_to_push_in_config = "SCREEN_LEVEL_MENU"
	
	if !C.SHOW_SETTINGS:
		btn_settings.hide()
