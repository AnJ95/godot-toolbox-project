extends "State.gd"

func on_enter():
	$Timer.start($Timer.wait_time)
	
func on_leave():
	pass

func can_get_damage()->bool:
	return false
func do_physics_process()->bool:
	return true

func _on_Timer_timeout():
	sm.goto_state("Alive")
