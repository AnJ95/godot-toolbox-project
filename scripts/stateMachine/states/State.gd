extends Node

var root:Node
var sm

func __on_before_enter(root, state_machine):
	self.root = root
	sm = state_machine

func on_enter():
	pass

func on_leave():
	pass

