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

const STREAM_WALK_DISTANCE = 42

#############################################################
# CUSTOMIZATION
export var control_scheme = ControlScheme.Platformer
export var die_on_level_leave = true

export(Array, Resource) var walk_sound_effects = []

#############################################################
# NODES
onready var sprite = $AnimatedSprite
onready var light = $Light2D

onready var stream_jump:AudioStreamPlayer2D = $StreamJump
onready var stream_walk:AudioStreamPlayer2D = $StreamWalk
onready var stream_damage:AudioStreamPlayer2D = $StreamDamage

#############################################################
# STATE
var skin_id = 0

var walking = false
var jumping = false

var stream_walk_distance = 0.0

#############################################################
# LIFECYCLE
func _ready():
	sprite.play()

	set_skin_texture(skins[skin_id])

func _on_level_started(level:Node):	
	# Reparent to new level
	.get_parent().remove_child(self)
	level.get_player_root_node().add_child(self)
	
	# Reset state
	flip = false
	walking = false
	jumping = false
	
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
func before_move_and_slide(delta):
	# Walking
	process_walk(delta)
	
func after_move_and_slide(delta):
	# Floored / Jump
	if control_scheme == ControlScheme.Platformer:
		process_jump(delta)
	
	# Skin selection
	process_skin(delta)
	
	# Sprite Animation
	process_sprite(delta)

	# Leaving Level Box
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
	var walk = walk_force * (Input.get_action_strength("game_right") - Input.get_action_strength("game_left"))
	
	# Slow down the player if they're not trying to move.
	if abs(walk) < walk_force * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, stop_force * delta)
		walking = false
	else:
		velocity.x += walk * delta
		walking = true
		
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -walk_max_speed, walk_max_speed)
	
	# Walking sound effect
	if is_on_floor():
		stream_walk_distance += abs(velocity.x) * delta
		process_stream_walk()
	
func process_walk_topdown(delta:float):
	# omnidirectional movement code. First, get the player's input.
	var x = walk_force * (Input.get_action_strength("game_right") - Input.get_action_strength("game_left"))
	var y = walk_force * (Input.get_action_strength("game_down") - Input.get_action_strength("game_up"))
	var walk = Vector2(x, y)
	
	if walk.length() < 0.2:
		velocity.x = move_toward(velocity.x, 0, stop_force * delta)
		velocity.y = move_toward(velocity.y, 0, stop_force * delta)
		walking = false
	else:
		velocity += walk * delta
		walking = true

	var vel_len = velocity.length()
	
	if vel_len > walk_max_speed:
		velocity = walk_max_speed * velocity.normalized()
		
	# Walking sound effect
	stream_walk_distance += vel_len * delta
	process_stream_walk()

# Handles floored state and triggers jump
# Must be called after move_and_slide
func process_jump(_delta:float):
	if is_on_floor():
		if jumping:
			jumping = false
		
		if Input.is_action_pressed("game_jump"):
			stream_jump.play()
			velocity.y = -jump_speed
			jumping = true


# Determines animation to play
# Must be called last
func process_sprite(_delta:float):
	if velocity.x > 0: flip = false
	if velocity.x < 0: flip = true
	sprite.flip_h = flip
	if jumping:
		sprite.animation = "jump"
	else:
		if walking:
			sprite.animation = "walk"
		else:
			sprite.animation = "idle"

#############################################################
# SKINS
func process_skin(_delta:float):
	var new_skin_id = skin_id
	if Input.is_action_just_pressed("game_switch_skin"):
		new_skin_id = (new_skin_id + 1) % skins.size()
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
# SOUNDS
func process_stream_walk():
	if stream_walk_distance >= STREAM_WALK_DISTANCE:
		stream_walk_distance -= STREAM_WALK_DISTANCE
		
		if walk_sound_effects.size() > 0:
			stream_walk.stream = walk_sound_effects[randi() % walk_sound_effects.size()]
		stream_walk.play()

#############################################################
# OVERRIDES
	
func _on_damaged():
	stream_damage.play(0)
	
func _on_die():
	SignalMngr.emit_signal("level_lost")
	
	
