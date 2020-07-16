extends Button

#############################################################
# CUSTOMIZATION

# Determines wether to switch the screen on click
export(bool) var pushes_screen = true
# Screen to switch to if pushes_screen==true
export(C.Screen) var screen_to_switch_to = C.Screen.GAME

# Determines wether to go to last screen on click
export(bool) var pops_screen = false

# Determines wether to quit the game on click
export(bool) var quits_game = false

# Determines wether to put initial focus on this button
export(bool) var grabs_focus = false

#############################################################
# LIFECYCLE
func _ready():
	if grabs_focus:
		grab_focus()

#############################################################
# CALLBACKS
func _on_MenuButton_pressed():
	if pops_screen:
		ScrnMngr.pop_screen()
		
	if pushes_screen:
		ScrnMngr.push_screen(screen_to_switch_to)
		
	if quits_game:
		ScrnMngr.exit_game()
