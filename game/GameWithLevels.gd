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
	if SignalMngr.connect("game_started", self, "_on_game_started") != OK:
		D.e("Game", ["Signal game_started is already connected"])
	if SignalMngr.connect("restart_level", self, "restart_level") != OK:
		D.e("Game", ["Signal restart_level is already connected"])
	if SignalMngr.connect("next_level", self, "next_level")!= OK:
		D.e("Game", ["Signal next_level is already connected"])

func _process(delta):
	_process_level(delta)
	
#############################################################
# SIGNALS
func _on_game_started():
	D.l("Game", ["Game started"])
	start_level(StateMngr.start_level_id if StateMngr.start_level_id != -1 else 0)

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
	if C.LEVELS.has(next_level_id):
		var next_level = C.LEVELS[next_level_id].instance()
		add_child(next_level)
		# save state
		cur_level_id = next_level_id
		current_level = next_level
		# trigger signal
		SignalMngr.emit_signal("level_started", next_level)
	else:
		D.e("Game", ["Could not start level with level id ", next_level_id, "- does it exist in the config?"])
	

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

