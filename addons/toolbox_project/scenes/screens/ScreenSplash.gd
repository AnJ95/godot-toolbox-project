extends Screen

func _ready():
	OS.center_window()
	
func _on_Timer_timeout():
	ScreenMngr.push_screen(C.SCREEN_MAIN_MENU if C.SHOW_MAIN_MENU else C.SCREEN_GAME)
