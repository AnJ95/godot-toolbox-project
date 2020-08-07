tool
extends "MobileControl.gd"

#############################################################
# CUSTOMIZATION
export var action = "game_jump"

#############################################################
# HANDLERS

func _on_touch():
	Input.call_deferred("action_press", action)

func _on_untouch():
	Input.call_deferred("action_release", action)
