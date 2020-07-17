extends Node2D

const Entity = preload("res://scenes/entities/Entity.gd")

export(Entity.Team) var team = Entity.Team.Player
var is_picked_up = false

func _on_Area2D_body_entered(entity:Node):
	if entity is Entity:
		if entity.team == team:
			if !is_picked_up:
				is_picked_up = true
				_on_picked_up(entity)
				queue_free()

func _on_picked_up(entity:Entity):
	# Increment Player Score
	# Access StateObject (triggers state_changed Signal)
	S.score.state += 1
