tool
extends CanvasLayer

onready var score_ui = $MarginContainer/TopLeft/HBoxContainer/IconIntValue
onready var health_ui = $MarginContainer/TopLeft/HBoxContainer/IconValue

func _ready():
	# Connect coin handler to State
	StateMngr.score.connect("state_changed", score_ui, "_on_update_int")
	#$MarginContainer.mouse_filter = $MarginContainer.MOUSE_FILTER_IGNORE
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() >= 1:
		players[0].connect("health_changed", health_ui, "update_value")

func _on_ButtonRestart_pressed():
	SignalMngr.emit_signal("restart_level")

func _on_ButtonPause_pressed():
	SignalMngr.emit_signal("game_paused", true)
