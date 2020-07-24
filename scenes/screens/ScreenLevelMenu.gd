tool
extends "res://scenes/screens/Screen.gd"

onready var menu = $MenuLayer/UIBox/VBoxContainer/Menu
func _ready():
	
	for child in menu.get_children():
		child.queue_free()
	
	for level_id in C.LEVELS.keys():
		# Create
		var btn:Button = Button.new()
		
		# Init
		btn.text = str(level_id)
		btn.connect("pressed", self, "_on_button_pressed", [level_id])
		btn.focus_mode = Button.FOCUS_NONE
		btn.disabled = !is_level_unlocked(level_id)
		btn.size_flags_horizontal = btn.SIZE_EXPAND_FILL
		
		# Add
		menu.add_child(btn)

func is_level_unlocked(level_id):
	return (
		level_id == 0 or
		PersistenceMngr.get_state("levelProgress." + str(level_id)) == true or
		PersistenceMngr.get_state("levelProgress." + str(level_id-1)) == true
	)

func _on_button_pressed(level_id):
	StateMngr.start_level_id = level_id
	ScreenMngr.push_screen(C.SCREEN_GAME)
