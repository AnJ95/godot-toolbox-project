tool
extends GridContainer

func _ready():
	$VBoxContainer7/ConfirmationDialog.visible = true
	#$VBoxContainer7/ConfirmationDialog.margin_top = 50
	
	var btn_option:OptionButton = $VBoxContainer8/OptionButton
	btn_option.clear()
	btn_option.add_item("High", 0)
	btn_option.add_item("Medium", 1)
	btn_option.add_item("Low", 2)
