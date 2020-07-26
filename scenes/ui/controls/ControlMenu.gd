tool
extends GridContainer

const ControlMenuAction = preload("res://scenes/ui/controls/ControlMenuAction.tscn")

export(String) var filter_actions:String = "^game_"

export var pretty_action_names = {
	"game_left" : "Left",
	"game_right" : "Right",
	"game_up" : "Up",
	"game_down" : "Down",
	"game_jump" : "Jump",
	"game_interact" : "Interact",
	"game_switch_demo" : "Switch Demo",
	"game_switch_skin" : "Switch Skin",
	"game_pause" : "Pause"
}

func _ready():
	var settingsControls = PersistenceMngr.get_state("settingsControls")
	
	var regex = RegEx.new()
	regex.compile(filter_actions)
	
	for action_name in settingsControls.keys():
		if !regex.search(action_name):
			continue
		
		var menu_action_inst = ControlMenuAction.instance()
		menu_action_inst.init(action_name)
		add_child(menu_action_inst)
