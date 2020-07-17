extends "Entity.gd"

onready var sprite = $AnimatedSprite
onready var camera = $LevelCamera

enum ControlScheme {
	Platformer,
	TopDown
}

export var control_scheme = ControlScheme.Platformer
export var die_on_level_leave = true

var level
var flip = false
var jumping = false
var is_dead = false

func _ready():
	sprite.play()
	
	# Await Level start
	Sgn.connect("level_started", self, "_on_level_started")
	Sgn.connect("player_died", self, "_on_player_died")
	

func _on_level_started(level:Node):
	# Reparent to new level
	self.level = level
	.get_parent().remove_child(self)
	level.add_child(self)
	
	# Reset
	is_dead = false
	
	# Initialize using level
	# start pos
	global_position = level.get_player_start_pos()
	# control scheme
	control_scheme = level.get_control_scheme()
	
func _on_player_died():
	is_dead = true
	Sgn.emit_signal("game_ended")
	
func _physics_process(delta):
	if is_dead:
		return
	
	# Walking
	process_walk(delta)
	
	# Vertical movement code. Apply gravity.
	velocity += level.gravity * delta

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

	# Floored / Jump
	if control_scheme == ControlScheme.Platformer:
		process_jump(delta)
	
	# Sprite Animation
	process_sprite(delta)

	
	if die_on_level_leave:
		if !level.get_map_rect().grow(50).has_point(global_position):
			Sgn.emit_signal("player_died")

# Calculates x-velocity for walking
# Must be called before move_and_slide
func process_walk(delta:float):
	match control_scheme:
		ControlScheme.Platformer:
			process_walk_platformer(delta)
		ControlScheme.TopDown:
			process_walk_topdown(delta)
			

func process_walk_platformer(delta:float):
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_action_strength("Right") - Input.get_action_strength("Left"))
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	
func process_walk_topdown(delta:float):
	# Horizontal movement code. First, get the player's input.
	var x = WALK_FORCE * (Input.get_action_strength("Right") - Input.get_action_strength("Left"))
	var y = WALK_FORCE * (Input.get_action_strength("Down") - Input.get_action_strength("Up"))
	
	
	if abs(x) < WALK_FORCE * 0.2: 	velocity.x = 	move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:						velocity.x += x * delta
	
	if abs(y) < WALK_FORCE * 0.2:	velocity.y = move_toward(velocity.y, 0, STOP_FORCE * delta)
	else:						velocity.y += y * delta
		
	# Clamp to the maximum movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	velocity.y = clamp(velocity.y, -WALK_MAX_SPEED, WALK_MAX_SPEED)

# Handles floored state and triggers jump
# Must be called after move_and_slide
func process_jump(delta:float):
	if is_on_floor():
		if jumping:
			jumping = false
		
		if Input.is_action_just_pressed("Jump"):
			velocity.y = -JUMP_SPEED
			jumping = true

# Determines animation to play
# Must be called last
func process_sprite(delta:float):
	if velocity.x > 0: flip = false
	if velocity.x < 0: flip = true
	sprite.flip_h = flip
	if jumping:
		sprite.animation = "jump"
	else:
		if abs(velocity.x) > 0.1:
			sprite.animation = "walk"
		else:
			sprite.animation = "idle"
