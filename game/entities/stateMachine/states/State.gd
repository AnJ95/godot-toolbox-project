extends Node

var root:Node
var sm

func __on_before_enter(root_node, state_machine):
	self.root = root_node
	sm = state_machine

func on_enter():
	pass

func on_leave():
	pass

func process(_delta:float):
	pass
