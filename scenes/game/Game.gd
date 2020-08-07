extends Node2D

#############################################################
# CONSTS


#############################################################
# STATE
var cur_level_id
var current_level
#############################################################
# LIFECYCLE
func _ready():

	# Connect Signals
	SignalMngr.connect("game_started", self, "_on_game_started")
	SignalMngr.connect("game_paused", self, "_on_game_paused")
	SignalMngr.connect("game_ended", self, "_on_game_ended")
	
	SignalMngr.connect("level_started", self, "_on_level_started")
	SignalMngr.connect("level_won", self, "_on_level_won")
	SignalMngr.connect("level_lost", self, "_on_level_lost")
	
	SignalMngr.connect("restart_level", self, "restart_level")
	SignalMngr.connect("next_level", self, "next_level")
	
	SignalMngr.emit_signal("game_started")
	
	start_level(StateMngr.start_level_id if StateMngr.start_level_id != -1 else 0)
	

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
	D.l("Game", ["Level started [", {
		"name" : level.name,
		"camera_type" : level.LevelCamera.CameraType.keys()[level.camera_type()],
		"control_scheme" : level.get_control_scheme(), 
		"map_rect" : level.get_map_rect(),
		"player_start_pos" : level.get_player_start_pos(),
	} , "]"])
	
func _on_level_lost():
	D.l("Game", ["Level lost"])
	
	if C.DIRECT_RESPAWN_ON_LEVEL_LOST:
		call_deferred("restart_level")

func _on_level_won():
	D.l("Game", ["Level won", cur_level_id])
	PersistenceMngr.set_state("levelProgress." + str(cur_level_id), true)
	
	if C.DIRECT_NEXT_ON_LEVEL_WON:
		call_deferred("next_level")

	
	
#############################################################
# LEVEL 
func start_level(next_level_id):
	StateMngr.score.state = 0
	
	# remove previous level
	if current_level != null:
		current_level.get_parent().remove_child(current_level)
		current_level.queue_free()
		current_level = null
	
	# instantiate and add new level
	var next_level = C.LEVELS[next_level_id].instance()
	add_child(next_level)
	
	# trigger signal
	SignalMngr.emit_signal("level_started", next_level)
	
	# save state
	cur_level_id = next_level_id
	current_level = next_level

func restart_level():
	start_level(cur_level_id)
func next_level():
	var next_level_id = cur_level_id + 1
	if next_level_id < C.LEVELS.size():
		start_level(next_level_id)
	else:
		D.l("Game", ["ALL LEVELS COMPLETED"])

func _process_level(_delta):
	# Switch Level with key "1"
	var last_level_id = cur_level_id
	if Input.is_action_just_pressed("game_switch_demo"):
		cur_level_id = (1 + cur_level_id) % C.LEVELS.size()
	if last_level_id != cur_level_id:
		start_level(cur_level_id)

