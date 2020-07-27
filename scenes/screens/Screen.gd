tool
extends Node2D

signal on_transition_closed()
signal on_transition_opened()

export(bool) var show_transition_on_enter = false
export(bool) var show_transition_on_leave = false
export(bool) var play_title_song = true

onready var transition = $Transition
 
func transition_close():
	transition.close()

func transition_open():
	transition.open()
	
func transition_open_immediately():
	if !transition: transition = $Transition
	transition.open_immediately()
