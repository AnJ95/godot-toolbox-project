tool
extends GridContainer

func _ready():
	#$VBoxContainer7/ConfirmationDialog.visible = true
	$VBoxContainer7/ConfirmationDialog.margin_top = 50
	
	$VBoxContainer8/OptionButton.add_item("High", 0)
	$VBoxContainer8/OptionButton.add_item("Medium", 1)
	$VBoxContainer8/OptionButton.add_item("Low", 2)
