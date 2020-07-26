extends Particles2D



func emit(root:Node, global_pos:Vector2):
	# Remove from parent if it has one
	if get_parent() != null:
		get_parent().remove_child(self)
	
	root.add_child(self)
	self.global_position = global_pos
	
	emitting = true
	
	$Timer.start(lifetime * 3)


func _on_Timer_timeout():
	queue_free()
