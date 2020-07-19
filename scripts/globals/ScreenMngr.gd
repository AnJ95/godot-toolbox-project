tool
extends Node

#############################################################
# STATE
var screen_history = []

#############################################################
# LIFECYCLE
func _ready():
	screen_history = [C.INITIAL_SCREEN]
	
#############################################################
# SWITCHING

# Switch to one of the Screens as specified in enum Config.Screen
func ___enter_screen(screen):
	
	# Dont't continue if invalid screen
	if !C.SCREEN_SCENES.keys().has(screen):
		D.l(D.LogCategory.SCREEN_MANAGER, ["Invalid screen supplied", screen], D.LogLevel.ERROR)
		return false
	
	# switch scene
	get_tree().change_scene(C.SCREEN_SCENES[screen])
	
	# Debug log & Signal
	D.l(D.LogCategory.SCREEN_MANAGER, ["Switched screen to", C.Screen.keys()[screen], C.SCREEN_SCENES.values()[screen]])
	SignalMngr.emit_signal("screen_entered", screen)
	
	return true
	

func ___exit_screen():
	if screen_history.size() >= 1:
		# Debug log & Signal
		D.l(D.LogCategory.SCREEN_MANAGER, ["Exited screen", C.Screen.keys()[screen_history[0]], C.SCREEN_SCENES.values()[screen_history[0]]])
		SignalMngr.emit_signal("screen_left", screen_history[0])
	
	return true

#############################################################
# INTERFACE
func reload_screen():
	___exit_screen()
	___enter_screen(screen_history[0])
	
func push_screen(screen):
	# Exit previous if existent
	___exit_screen()
	# Try changing scene
	if ___enter_screen(screen):
		screen_history.push_front(screen)
		return true
	return false

func pop_screen():
	if screen_history.size() <= 1:
		D.l(D.LogCategory.SCREEN_MANAGER, ["Tried popping Screen, but the screen_history buffer would have been empty"], D.LogLevel.ERROR)
		return false
	
	___exit_screen()
	
	screen_history.pop_front()
	if ___enter_screen(screen_history[0]):
		return true

func exit_game():
	get_tree().quit()
