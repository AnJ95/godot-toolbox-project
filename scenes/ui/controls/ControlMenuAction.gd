extends Control

const ControlMenuButton = preload("res://scenes/ui/controls/ControlMenuButton.tscn")

onready var label = $Label

var action_name

func init(action_name):
	self.action_name = action_name
	
func _ready():
	label.text = action_name
	
	var settings = PersistenceMngr.get_state("settingsControls")[action_name]
	
	for i in range(settings.size()):
		var btn_inst = ControlMenuButton.instance()
		btn_inst.init(action_name, i)
		add_child(btn_inst)
