extends Node

func _ready():
	if get_state():
		get_state().__on_before_enter(get_parent(), self)
		get_state().on_enter()
			
func goto_state(state:String):
	print(state)
	if get_state():
		get_state().on_leave()
		
	for child in get_children():
		if child.name == state:
			child.__on_before_enter(get_parent(), self)
			child.on_enter()
			move_child(child, 0)
	
func get_state():
	return get_children()[0] if get_child_count() > 0 else null
