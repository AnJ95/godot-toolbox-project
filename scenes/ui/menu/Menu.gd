tool
extends GridContainer

signal button_pressed(button_name)

#############################################################
# CUSTOMIZATION

export(Array, Array, String) var menu_buttons = [
	["Start Game", "gameStart"],
	["Options", "options"],
	["Quit Game", "gameQuit"]
] setget _set_menu_buttons

#############################################################
# SETTERS
func _set_menu_buttons(v):
	menu_buttons = v
	remove_all_buttons()
	add_all_buttons()
	
#############################################################
# LIFECYCLE
func _ready():
	remove_all_buttons()
	add_all_buttons()

#############################################################
# BUTTON ADDING & REMOVING
func add_all_buttons():
	for button in menu_buttons:
		add_button(button[1], button[0])
		
func remove_all_buttons():
	for btn in get_children():
		btn.queue_free()
	
func add_button(name, caption):
	var btn:Button = Button.new()
	
	btn.name = name
	btn.text = caption
	btn.size_flags_horizontal |= SIZE_EXPAND
	btn.size_flags_vertical |= SIZE_EXPAND
	btn.connect("pressed", self, "_on_button_pressed", [name])
	
	add_child(btn)
	
	D.l(D.LogCategory.MENU, ["Added menu button [ Caption:", caption, ",", "Name:", name, "]"])

#############################################################
# CALLBACK
func _on_button_pressed(button_name):
	D.l(D.LogCategory.MENU, ["Pressed menu button [ Name:", button_name, "]"])
	emit_signal("button_pressed", button_name)
