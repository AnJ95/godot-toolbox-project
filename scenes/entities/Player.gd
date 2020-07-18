extends "Entity.gd"

#############################################################
# CONSTANTS
const skins = [
	preload("res://assets/sprites/entities/knight.png"),
	preload("res://assets/sprites/entities/human.png"),
	preload("res://assets/sprites/entities/wizard.png"),
	preload("res://assets/sprites/entities/dino.png")	
]

enum ControlScheme {
	Platformer,
	TopDown
}

#############################################################
# CUSTOMIZATION
export var control_scheme = ControlScheme.Platformer
export var die_on_level_leave = true

#############################################################
# NODES
onready var sprite = $AnimatedSprite
onready var light = $Light2D

#############################################################
# STATE
var level

var skin_id = 0

var flip = false
var jumping = false

#############################################################
# LIFECYCLE
func _ready():
	sprite.play()

	set_skin_texture(skins[skin_id])

func _on_level_started(level:Node):	
	
	# Reparent to new level
	self.level = level
	.get_parent().remove_child(self)
	level.add_child(self)
	
	# Initialize using level
	# start pos
	global_position = level.get_player_start_pos()
	# control scheme
	control_scheme = level.get_control_scheme()
	# light source attached to player?
	light.enabled = level.give_player_light()
	
	._on_level_started(level)
	# Trigger health changed for UI
	emit_signal("health_changed", get_health_now(), get_health_max())

#############################################################
# PROCESS	
func _physics_process(delta):
	if !sm_lifecycle.get_state().do_physics_process():
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
	
	# Skin selection
	process_skin(delta)
	
	# Sprite Animation
	process_sprite(delta)

	if die_on_level_leave:
		if !level.get_map_rect().grow(80).has_point(global_position):
			deal_damage(1000)

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

#############################################################
# SKINS
func process_skin(_delta:float):
	var new_skin_id = skin_id
	if Input.is_action_just_pressed("NextSkin"):		new_skin_id += 1
	if Input.is_action_just_pressed("PrevSkin"):		new_skin_id -= 1
	new_skin_id = clamp(new_skin_id, 0, skins.size() - 1)
	if new_skin_id != skin_id:
		skin_id = new_skin_id
		set_skin_texture(skins[skin_id])
		
	
func set_skin_texture(txt:Texture):
	var frames = $AnimatedSprite.frames
	for anim_name in frames.get_animation_names():
		for f in range(frames.get_frame_count(anim_name)):
			var prev_atlas = frames.get_frame(anim_name, f)
			var atlas:AtlasTexture = AtlasTexture.new()

			atlas.atlas = txt
			atlas.margin = prev_atlas.margin
			atlas.region = prev_atlas.region

			frames.set_frame(anim_name, f, atlas)

#############################################################
# OVERRIDES
func _on_die():
	Sgn.emit_signal("player_died")
	
	
