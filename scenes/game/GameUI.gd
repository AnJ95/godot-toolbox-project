tool
extends CanvasLayer


func _ready():
	# Connect coin handler to State 
	S.score.connect("state_changed", $TopLeft/HBoxContainer/IconIntValue, "_on_update_int")
	
	
