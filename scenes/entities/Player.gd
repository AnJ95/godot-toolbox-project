extends "Entity.gd"

onready var sprite = $AnimatedSprite
onready var camera = $LevelCamera

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
	# reparent to new level
	self.level = level
	.get_parent().remove_child(self)
	level.add_child(self)
	
	# initialize
	global_position = level.get_player_start_pos()
	is_dead = false
	if level.camera_on_player: camera.current = true
	
	
func _on_player_died():
	is_dead = true
	Sgn.emit_signal("game_ended")
	
func _physics_process(delta):
	if is_dead:
		return
		
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
	
	# Vertical movement code. Apply gravity.
	velocity.y += GRAVITY * delta

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

	if is_on_floor() and jumping:
		jumping = false
		
	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		velocity.y = -JUMP_SPEED
		jumping = true
	
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

	
	if die_on_level_leave:
		if !level.get_map_rect().grow(50).has_point(global_position):
			Sgn.emit_signal("player_died")
	
