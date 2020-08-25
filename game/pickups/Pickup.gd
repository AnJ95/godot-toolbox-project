extends Node2D

const Entity = preload("res://game/entities/Entity.gd")

export(Entity.Team) var team = Entity.Team.Player
export(Array, Resource) var on_pickup_sounds = []
export(PackedScene) var on_pickup_particles

var is_picked_up = false

onready var audioStreamPlayer:AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_Area2D_body_entered(entity:Node):
	if !entity is Entity:
		return
	if entity.team != team:
		return
	if is_picked_up:
		return
				
	is_picked_up = true
	$AnimatedIcon.visible = false
	
	_on_picked_up(entity)
	
	if on_pickup_sounds.size() > 0:
		audioStreamPlayer.stream = on_pickup_sounds[randi()%on_pickup_sounds.size()]
		audioStreamPlayer.play()
		
	if on_pickup_particles:
		var inst = on_pickup_particles.instance()
		inst.emit(get_parent(), global_position)
		
	if on_pickup_sounds.size() > 0:
		yield(audioStreamPlayer, "finished")
	
	queue_free()

func _on_picked_up(_entity:Entity):
	pass
	
	
