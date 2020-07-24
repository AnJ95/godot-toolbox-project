extends "res://scenes/screens/Screen.gd"

func _on_Timer_timeout():
	print(C.SCREEN_MAIN_MENU if C.SHOW_MAIN_MENU else C.SCREEN_GAME)
	ScreenMngr.push_screen(C.SCREEN_MAIN_MENU if C.SHOW_MAIN_MENU else C.SCREEN_GAME)
