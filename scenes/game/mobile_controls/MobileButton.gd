tool
extends "res://scenes/game/mobile_controls/MobileControl.gd"

#############################################################
# CUSTOMIZATION
export var action = "Jump"

#############################################################
# HANDLERS

func _on_MobileJoystick_button_down():
	Input.call_deferred("action_press", action)

func _on_MobileJoystick_button_up():
	Input.call_deferred("action_release", action)
