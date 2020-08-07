extends Node2D

const Level = preload("res://game/levels/PlatformerDarkCave.tscn")
var level 

#############################################################
# LIFECYCLE
func _ready():
	# Connect Signals
	SignalMngr.connect("game_started", self, "_on_game_started")
	SignalMngr.connect("game_paused", self, "_on_game_paused")
	SignalMngr.connect("game_ended", self, "_on_game_ended")
	
	SignalMngr.connect("level_won", self, "_on_level_won")
	SignalMngr.connect("level_lost", self, "_on_level_lost")
	
	SignalMngr.connect("restart_level", self, "restart_level")
	SignalMngr.connect("next_level", self, "next_level")
	
	# Notify ready
	SignalMngr.emit_signal("game_started")
	start_level()
	
	
#############################################################
# SIGNALS
func _on_game_started():
	D.l("Game", ["Game started"])
	
func _on_game_ended():
	D.l("Game", ["Game ended"])
	
func _on_game_paused(pause_on):
	D.l("Game", ["Game paused", pause_on])

func start_level():
	StateMngr.score.state = 0
	if level:
		remove_child(level)
		level.queue_free()
	level = Level.instance()
	add_child(level)
	SignalMngr.emit_signal("level_started", level)

func _on_level_lost():
	D.l("Game", ["Level lost"])
	
	if C.DIRECT_RESPAWN_ON_LEVEL_LOST:
		call_deferred("restart_level")

func _on_level_won():
	D.l("Game", ["Level won"])
	
	if C.DIRECT_NEXT_ON_LEVEL_WON:
		call_deferred("next_level")
		
func restart_level():
	start_level()
	
func next_level():
	start_level()

