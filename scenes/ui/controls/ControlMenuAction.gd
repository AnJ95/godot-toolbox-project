extends Control

const ControlMenuButton = preload("res://scenes/ui/controls/ControlMenuButton.tscn")

onready var label = $HBoxContainer/Label
onready var btn_root = $ControlMenuButtons

var action_name

func init(action_name):
	self.action_name = action_name
	
func _ready():
	if get_parent().pretty_action_names.has(action_name):
		label.text = get_parent().pretty_action_names[action_name]
	else:
		label.text = action_name
	
	var settings = PersistenceMngr.get_state("settingsControls")[action_name]
	
	for i in range(settings.size()):
		add_button()

func add_button():
	var btn_inst = ControlMenuButton.instance()
	btn_inst.init(action_name, btn_root.get_child_count())
	btn_inst.get_node("ButtonRemove").connect("pressed", self, "_on_ButtonRemove_pressed", [btn_inst])
	btn_root.add_child(btn_inst)

func _on_ButtonAdd_pressed():
	var settings = PersistenceMngr.get_state("settingsControls")[action_name]
	settings.append(null)
	add_button()
	
func _on_ButtonRemove_pressed(btn):
	var settings = PersistenceMngr.get_state("settingsControls")[action_name]
	settings.remove(btn.event_i)
	PersistenceMngr.set_state("settingsControls." + str(action_name), settings)
	
	btn_root.remove_child(btn_root.get_children()[btn.event_i])
	
	for i in range(btn_root.get_child_count()):
		btn_root.get_children()[btn.event_i].event_i = btn.event_i
