extends HBoxContainer

export var trailing_zeroes = 2

onready var label = $Label

func _on_update_int(int_text:int):
	var str_text = str(int_text)
	
	# add trailing 0s if configured
	while str_text.length() < trailing_zeroes:
		str_text = "0" + str_text
		
	label.text = str_text
	
