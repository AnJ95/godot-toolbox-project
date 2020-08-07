tool
extends Node2D
class_name Screen

signal on_transition_closed()
signal on_transition_opened()

export(bool) var show_transition_on_enter = false
export(bool) var show_transition_on_leave = false
export(bool) var play_title_song = true

const Transition = preload("res://addons/toolbox_project/scenes/transition/Transition.tscn")
onready var transition = $Transition

func _ready():
	pass
	if !transition:
		transition = Transition.instance()
		add_child(transition)
	
func transition_close():
	transition.close()

func transition_open():
	transition.open()
	
func transition_open_immediately():
	if !transition: transition = $Transition
	transition.open_immediately()
