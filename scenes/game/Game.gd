extends Node2D

#############################################################
# CONSTS
const levels = {
	0:		preload("res://scenes/game/levels/PlatformerAutotile.tscn"),
	1:		preload("res://scenes/game/levels/PlatformerDarkCave.tscn"),
	2:		preload("res://scenes/game/levels/PlatformerParallax.tscn"),
	3:		preload("res://scenes/game/levels/TopDownDungeonMystery.tscn"),
	4:		preload("res://scenes/game/levels/TopDownIsometric.tscn")
}

#############################################################
# STATE
var cur_level_id = 0
var current_level
#############################################################
# LIFECYCLE
func _ready():

	# Connect Signals
	SignalMngr.connect("game_started", self, "_on_game_started")
	SignalMngr.connect("game_paused", self, "_on_game_paused")
	SignalMngr.connect("game_ended", self, "_on_game_ended")
	
	SignalMngr.connect("level_started", self, "_on_level_started")
	SignalMngr.connect("level_restarted", self, "_on_level_restarted")
	
	SignalMngr.emit_signal("game_started")
	
	start_level(cur_level_id)
	

func _process(delta):
	_process_level(delta)
	
#############################################################
# SIGNALS
func _on_game_started():
	D.l("Game", ["Game started"])
	
func _on_game_ended():
	D.l("Game", ["Game ended"])
	restart_level()
	
func _on_game_paused(pause_on):
	D.l("Game", ["Game paused", pause_on])
	
func _on_level_started(level:Node):
	pass

func _on_level_restarted():
	restart_level()
	
#############################################################
# LEVEL 
func start_level(next_level_id):
	# remove previous level
	if current_level != null:
		current_level.get_parent().remove_child(current_level)
		current_level.queue_free()
		current_level = null
	
	# instantiate and add new level
	var next_level = levels[next_level_id].instance()
	add_child(next_level)
	current_level = next_level
	
	SignalMngr.emit_signal("level_started", next_level)

func restart_level():
	start_level(cur_level_id)

func _process_level(_delta):
	# Switch Level with Q and E keys
	var last_level_id = cur_level_id
	if Input.is_action_just_pressed("PrevDemo"):		cur_level_id -= 1
	if Input.is_action_just_pressed("NextDemo"):		cur_level_id += 1
	cur_level_id = clamp(cur_level_id, 0, levels.size()-1)
	
	if last_level_id != cur_level_id:
		start_level(cur_level_id)

