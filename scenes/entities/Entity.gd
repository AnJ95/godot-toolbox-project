extends KinematicBody2D

#############################################################
# NODES
onready var sm_lifecycle = $StateMachineLifecycle

#############################################################
# WALKING CONSTANTS
const WALK_FORCE = 500
const WALK_MAX_SPEED = 120
const STOP_FORCE = 1900
const JUMP_SPEED = 220

var velocity = Vector2()

#############################################################
# HEALTH
export var __health_now = 3
export var __health_max = 3
signal health_changed(health_now, health_max)

export var revive_on_level_start = true

func deal_damage(dmg):
	var can_get_dmg = sm_lifecycle.get_state().can_get_damage()
	if can_get_dmg:
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
export var team = Team.Player

func _ready():
	# Await Level start
	Sgn.connect("game_started", self, "_on_game_started")
	Sgn.connect("level_started", self, "_on_level_started")

func _on_game_started():
	# Reset
	__health_now = __health_max
	sm_lifecycle.goto_state("Alive")
		
func _on_level_started(_level):
	# Reset
	if revive_on_level_start:
		__health_now = __health_max
		sm_lifecycle.goto_state("Alive")
	
#############################################################
# OVERRIDES
func _on_die():
	queue_free()


