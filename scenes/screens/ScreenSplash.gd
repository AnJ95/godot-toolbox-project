extends Node2D

func _on_Timer_timeout():
	ScreenMngr.push_screen(C.Screen.MAIN_MENU if C.SHOW_MAIN_MENU else C.Screen.GAME)
