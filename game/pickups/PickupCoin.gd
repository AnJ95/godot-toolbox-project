extends "res://game/pickups/Pickup.gd"

func _on_picked_up(_entity:Entity):
	# Increment Player Score
	# Access StateObject (triggers state_changed Signal)
	StateMngr.score.state += 1
