extends Node2D

func _on_Timer_timeout():
	ScrnMngr.push_screen(C.Screen.MAIN_MENU)
