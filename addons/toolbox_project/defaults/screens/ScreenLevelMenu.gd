tool
extends Screen

onready var menu = $MenuLayer/UIBox/PanelContainer/VBoxContainer/Menu
func _ready():
	
	for child in menu.get_children():
		child.queue_free()
	
	
	for level_id in C.LEVELS.keys():
		# Create
		var btn:Button = Button.new()
		
		# Init
		btn.text = str(level_id + 1)
		btn.connect("pressed", self, "_on_button_pressed", [level_id])
		btn.disabled = !is_level_unlocked(level_id)
		btn.size_flags_horizontal = btn.SIZE_EXPAND_FILL
		
		# Add
		menu.add_child(btn)
		
	grab_focus_on_last_clickable_btn()
	
func _enter_tree():
	call_deferred("grab_focus_on_last_clickable_btn")

func grab_focus_on_last_clickable_btn():
	if !menu:
		return
	var last_clickable_btn = null
	for btn in menu.get_children():
		if btn is Button and !btn.disabled:
			last_clickable_btn = btn
	if last_clickable_btn:
		last_clickable_btn.grab_focus()

func is_level_unlocked(level_id):
	return (
		level_id == 0 or
		PersistenceMngr.get_state("levelProgress." + str(level_id)) or
		PersistenceMngr.get_state("levelProgress." + str(level_id-1))
	)

func _on_button_pressed(level_id):
	SoundMngr.play_ui_sound(C.UI_SELECT)
	StateMngr.start_level_id = level_id
	ScreenMngr.push_screen(C.SCREEN_GAME)
