tool
extends CanvasLayer

onready var score_ui = $MarginContainer/TopLeft/HBoxContainer/IconIntValue
onready var health_ui = $MarginContainer/TopLeft/HBoxContainer/IconValue

func _ready():
	# Connect coin handler to State 
	S.score.connect("state_changed", score_ui, "_on_update_int")
	#$MarginContainer.mouse_filter = $MarginContainer.MOUSE_FILTER_IGNORE
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() >= 1:
		players[0].connect("health_changed", health_ui, "update_value")

func _on_ButtonRestart_pressed():
	Sgn.emit_signal("level_restarted")

func _on_ButtonPause_pressed():
	Sgn.emit_signal("game_paused", true)
