extends "State.gd"

export(Gradient) var modulate_gradient:Gradient
export var invulnerability_time = 0.8
export var anim_runs = 2

func on_enter():
	$Timer.start(invulnerability_time)
	root.modulate = modulate_gradient.interpolate(0)
	
func on_leave():
	root.modulate = modulate_gradient.interpolate(1)
	
func process(delta):
	# [0, 1]
	var t = 1 - $Timer.time_left / invulnerability_time
	# [0, anim_runs]
	t *= anim_runs
	# [0, 1, ... 0, 1]
	t = fmod(t, 1)
	root.modulate = modulate_gradient.interpolate(t)

func can_get_damage()->bool:
	return false
func do_physics_process()->bool:
	return true

func _on_Timer_timeout():
	sm.goto_state("Alive")
