extends "State.gd"

func on_enter():
	root.connect("health_changed", self, "_on_health_changed")

var last_health
func _on_health_changed(health_now, health_max):
	if health_now <= 0:
		sm.goto_state("Dead")
		last_health = health_now
		return
	if last_health and health_now < last_health:
		sm.goto_state("Invulnerable")
	last_health = health_now

func can_get_damage()->bool:
	return true
func do_physics_process()->bool:
	return true
	
func on_leave():
	root.disconnect("health_changed", self, "_on_health_changed")

