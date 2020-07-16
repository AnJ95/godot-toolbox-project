extends Node2D

#############################################################
# NODES
onready var background = $GameBackground
onready var ui = $GameUI
onready var pause = $GamePause

#############################################################
# STATE
var levels
var cur_level_id = 0

#############################################################
# LIFECYCLE
func _ready():
	# Connect Signals
	Sgn.connect("game_started", self, "_on_game_started")
	Sgn.connect("game_paused", self, "_on_game_paused")
	Sgn.connect("game_ended", self, "_on_game_ended")
	
	Sgn.connect("level_started", self, "_on_level_started")
	
	Sgn.emit_signal("game_started")
	
	levels = get_tree().get_nodes_in_group("TileMapDemo")
	start_level(levels[cur_level_id])

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
	
func _on_level_started(root:Node):
	D.l("Game", ["Level started [", "RootNode:", root.name, "]"])
	
#############################################################
# LEVEL 
func start_level(level):
	Sgn.emit_signal("level_started", level)

func restart_level():
	start_level(levels[cur_level_id])

func _process_level(_delta):
	# Switch Level with Q and E keys
	var last_level_id = cur_level_id
	if Input.is_action_just_pressed("PrevDemo"):		cur_level_id -= 1
	if Input.is_action_just_pressed("NextDemo"):		cur_level_id += 1
	cur_level_id = clamp(cur_level_id, 0, levels.size()-1)
	
	if last_level_id != cur_level_id:
		start_level(levels[cur_level_id])

