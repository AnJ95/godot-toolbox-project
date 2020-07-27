extends "res://scripts/stateMachine/states/State.gd"

func on_enter():
	$Timer.start()
	root.get_node("AnimatedSprite").animation = "idle"

func on_leave():
	$Timer.stop()

func process(delta:float):
	root.velocity.x = move_toward(root.velocity.x, 0, root.stop_force * delta)

func _on_Timer_timeout():
	sm.goto_state("Walking")
