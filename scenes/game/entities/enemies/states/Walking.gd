extends "res://scripts/stateMachine/states/State.gd"

var direction = Vector2(1, 0) # must be normalized
var sprite:AnimatedSprite


func on_enter():
	$Timer.start()
	sprite = root.get_node("AnimatedSprite")
	sprite.animation = "walk"

func on_leave():
	$Timer.stop()

func turn_around():
	direction.x *= -1
	root.velocity.x *= -1
			
var cliff_falloff_cooldown = 0
func process(delta:float):
	
	# Determine if there was a wall collision
	for i in range(root.get_slide_count()):
		if abs(root.get_slide_collision(i).normal.x) > 0.8:
			turn_around()
	
	# Prevent from falling of edges
	if cliff_falloff_cooldown <= 0:
		if !root.raycast.is_colliding():
			turn_around()
			cliff_falloff_cooldown = 0.25
	else:
		cliff_falloff_cooldown -= delta

	# calculate velocity
	var walk = root.walk_force * direction 
	var v = root.velocity
	v += walk * delta
	v.x = clamp(v.x, -root.walk_max_speed, root.walk_max_speed)
	root.velocity = v
	
	# flip Sprite
	if v.x > 0: sprite.flip_h = false
	if v.x < 0: sprite.flip_h = true

func _on_Timer_timeout():
	sm.goto_state("Idle")
