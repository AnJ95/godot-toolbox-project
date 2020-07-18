extends "State.gd"

onready var tween:Tween = $Tween

func on_enter():
	var sprite:AnimatedSprite = root.get_node("AnimatedSprite")
	var sgn = -1 if sprite.flip_h else 1
	tween.interpolate_property(sprite, "rotation", 0.0, sgn*(1.25)*(2*PI), 0.8)
	tween.start()
	
func on_leave():
	pass
	
func process(delta:float):
	pass

func can_get_damage()->bool:
	return false
func do_physics_process()->bool:
	return false
