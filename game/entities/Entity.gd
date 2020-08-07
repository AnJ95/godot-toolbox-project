extends KinematicBody2D

#############################################################
# NODES
onready var sm_lifecycle = $StateMachineLifecycle
onready var raycast:RayCast2D = $RayCast2D

#############################################################
# WALKING CONSTANTS
export var walk_force = 500
export var walk_max_speed = 120
export var stop_force = 1900
export var jump_speed = 220

#############################################################
# CUSTOMIZATION
export(bool) var do_contact_damage:bool = false
export(float) var contact_damage:float = 0.5
export var affected_by_gravity = true
export var revive_on_level_start = true

#############################################################
# HEALTH
export(float) var __health_now = 3.0
export(float) var __health_max = 3.0
signal health_changed(health_now, health_max)

#############################################################
# STATE
var level
var flip = false
var velocity = Vector2()

func deal_damage(dmg):
	var can_get_dmg = sm_lifecycle.get_state().can_get_damage()
	if can_get_dmg:
		_on_damaged()
		__health_now = clamp(__health_now - dmg, 0, __health_max)
		emit_signal("health_changed", __health_now, __health_max)
	
func add_health(health):
	__health_now = clamp(__health_now + health, 0, __health_max)
	emit_signal("health_changed", __health_now, __health_max)

func get_health_now(): return __health_now
func get_health_max(): return __health_max

#############################################################
# TEAM
enum Team {
	Player,
	Enemy
}
export(Team) var team = Team.Player

#############################################################
# LIFECYCLE
func _ready():
	# Await Level start
	SignalMngr.connect("game_started", self, "_on_game_started")
	SignalMngr.connect("level_started", self, "_on_level_started")
	
	$ContactArea.monitoring = do_contact_damage
		

func _on_game_started():
	# Reset
	__health_now = __health_max
	sm_lifecycle.goto_state("Alive")
		
func _on_level_started(level):
	self.level = level
	
	# Reset
	if revive_on_level_start:
		__health_now = __health_max
		sm_lifecycle.goto_state("Alive")
		
#############################################################
# PROCESS
func _physics_process(delta):
	# Cancel if dead by lifecycle
	if !sm_lifecycle.get_state().do_physics_process():
		return
	
	before_move_and_slide(delta)
	
	# Apply gravity.
	if affected_by_gravity:
		velocity += level.gravity * delta
			
	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	after_move_and_slide(delta)
	
	# Deal damage if touching target
	if do_contact_damage:
		for contact in contacts:
			contact.deal_damage(contact_damage)
	
func before_move_and_slide(delta):
	pass
	
func after_move_and_slide(delta):
	pass
	
#############################################################
# CONTACT DAMAGE
var contacts = []
func can_have_contact_with(body)->bool:
	return do_contact_damage and body.has_method("__is_entity") and body.team != team

func _on_ContactArea_body_entered(body:Node):
	if can_have_contact_with(body):
		contacts.append(body)
		
func _on_ContactArea_body_exited(body):
	if can_have_contact_with(body):
		contacts.erase(body)

#############################################################
# A LITTLE HACKY
func __is_entity():
	return true
#############################################################
# OVERRIDES
func _on_die():
	queue_free()

func _on_damaged():
	pass


