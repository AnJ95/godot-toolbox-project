tool
extends GridContainer

#############################################################
# CONSTANTS
const MenuSlider = preload("res://scenes/ui/menu/MenuSlider.tscn")

#############################################################
# SIGNALS
signal button_pressed(button_name)
signal slider_changed(slider_name, value)

#############################################################
# CUSTOMIZATION

export(Array, Array, String) var menu_items = [
	["button", "Start Game", "gameStart"],
	["button", "Options", "options"],
	["button", "Quit Game", "gameQuit"]
] setget _set_menu_items

#############################################################
# SETTERS
func _set_menu_items(v):
	menu_items = v
	if Engine.is_editor_hint():
		remove_all_menu_items()
		add_all_menu_items()
	
#############################################################
# LIFECYCLE
func _ready():
	remove_all_menu_items()
	add_all_menu_items()

#############################################################
# BUTTON ADDING & REMOVING
func add_all_menu_items():
	for item in menu_items:
		match item[0]:
			"button":
				add_button(item[2], item[1])
			"slider":
				add_slider(item[2], item[1], item[3], item[4], item[5], item[6])
			_:
				D.l(D.LogCategory.MENU, ["Invalid menu item type supplied:", item[0]], D.LogLevel.ERROR)
		
func remove_all_menu_items():
	for item in get_children():
		item.queue_free()


func add_slider(name, caption, value, value_min, value_max, value_step):
	var slider = MenuSlider.instance().init(caption, value, value_min, value_max, value_step)
	
	slider.connect("slider_changed", self, "_on_slider_changed", [name])
	
	add_child(slider)
	
	D.l(D.LogCategory.MENU, ["Added slider [ Caption:", caption, ",", "Name:", name, ", Range:[", value_min, ":", value_step, ":", value_max, "], Value:[", value, "]]"])
	
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

func _on_slider_changed(value, slider_name):
	D.l(D.LogCategory.MENU, ["Changed slider [ Name:", slider_name, ",", "Value:", value, "]"])
	emit_signal("slider_changed", slider_name, value)
