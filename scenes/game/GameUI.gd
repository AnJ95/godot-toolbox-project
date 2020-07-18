tool
extends CanvasLayer

onready var score_ui = $TopLeft/HBoxContainer/IconIntValue
onready var health_ui = $TopLeft/HBoxContainer/IconValue

func _ready():
	# Connect coin handler to State 
	S.score.connect("state_changed", score_ui, "_on_update_int")
	
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() >= 1:
		players[0].connect("health_changed", health_ui, "update_value")
	
	
