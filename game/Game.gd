extends Node2D

const Level = preload("res://game/levels/PlatformerDarkCave.tscn")
var level 

#############################################################
# LIFECYCLE
func _ready():
	# Connect Signals
	SignalMngr.connect("game_started", self, "_on_game_started")
	SignalMngr.connect("restart_level", self, "restart_level")
	SignalMngr.connect("next_level", self, "next_level")
	
func start_level():
	StateMngr.score.state = 0
	if level:
		remove_child(level)
		level.queue_free()
	level = Level.instance()
	add_child(level)
	SignalMngr.emit_signal("level_started", level)


func _on_game_started():
	start_level()
	
func restart_level():
	start_level()

func next_level():
	start_level()

