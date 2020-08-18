extends Screen

func _ready():
	# Connect Signals
	SignalMngr.connect("game_started", self, "_on_game_started")
	SignalMngr.connect("game_paused", self, "_on_game_paused")
	SignalMngr.connect("game_ended", self, "_on_game_ended")
	
	SignalMngr.connect("level_started", self, "_on_level_started")
	SignalMngr.connect("level_won", self, "_on_level_won")
	SignalMngr.connect("level_lost", self, "_on_level_lost")
	
	# Notify ready
	SignalMngr.call_deferred("emit_signal", "game_started")
	
	# Remove dialogs if not required
	if C.DIRECT_RESPAWN_ON_LEVEL_LOST:
		$GameDialogLost.queue_free()
	if C.DIRECT_NEXT_ON_LEVEL_WON:
		$GameDialogWon.queue_free()
	


#############################################################
# SIGNALS
func _on_game_started():
	D.l("Game", ["Game started"])
	
func _on_game_ended():
	D.l("Game", ["Game ended"])
	
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
		SignalMngr.call_deferred("emit_signal", "restart_level")

func _on_level_won():
	D.l("Game", ["Level won"])
	
	if C.DIRECT_NEXT_ON_LEVEL_WON:
		SignalMngr.call_deferred("emit_signal", "next_level")
