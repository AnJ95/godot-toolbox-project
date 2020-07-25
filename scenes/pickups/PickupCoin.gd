extends "res://scenes/pickups/Pickup.gd"

func _on_picked_up(entity:Entity):
	# Increment Player Score
	# Access StateObject (triggers state_changed Signal)
	StateMngr.score.state += 1
