extends Node

const ScreenGD = preload("res://addons/toolbox_project/scenes/screens/Screen.gd")

#############################################################
# STATE
var screen_history = []

#############################################################
# LIFECYCLE
func _ready():
	for child in get_tree().root.get_children():
		if child is Screen:
			screen_history = [child]
			break
			
	if screen_history.size() != 1:
		D.e(D.LogCategory.SCREEN_MANAGER, ["Initial scene is not a is not inherited from Screen.tscn!"])
		return
	screen_history[0].transition_open_immediately()
	
	
#############################################################
# SWITCHING

# Switch to one of the Screens as specified in enum Config.Screen
func ___enter_screen(screen):
	# add scene
	get_tree().root.add_child(screen)
	
	# Debug log & Signal
	D.l(D.LogCategory.SCREEN_MANAGER, ["Switched screen to", screen.name])
	SignalMngr.emit_signal("screen_entered", screen)
	

func ___exit_screen():
	# remove scene
	get_tree().root.remove_child(screen_history[0])
	
	# Debug log & Signal
	D.l(D.LogCategory.SCREEN_MANAGER, ["Exited screen", screen_history[0].name])
	SignalMngr.emit_signal("screen_left", screen_history[0])

#############################################################
# INTERFACE
func reload_screen():
	___exit_screen()
	___enter_screen(screen_history[0])
	
func push_screen(screen_scene):
	
	if !screen_scene:
		D.e(D.LogCategory.SCREEN_MANAGER, ["Invalid screen to push supplied."])
		return
		
	var screen_inst = screen_scene.instance()
	
	# show transition if (new screen wants to on enter) or (prev screen wants to on leave)
	var show_transition = screen_inst.show_transition_on_enter or (screen_history.size() >= 1 and screen_history[0].show_transition_on_leave)
	
	if !screen_inst is ScreenGD:
		D.e(D.LogCategory.SCREEN_MANAGER, ["Tried pushing Screen, but it is not a PackedScene, inherited from Screen.tscn"])
		return
	
	if show_transition and screen_history.size() >= 1:
		screen_history[0].transition_close()
		yield(screen_history[0], "on_transition_closed")
	
	# Exit previous if existent
	___exit_screen()
	
	# Change scene
	___enter_screen(screen_inst)
	screen_history.push_front(screen_inst)
	
	if show_transition:
		screen_history[0].transition_open()
		yield(screen_history[0], "on_transition_opened")
	else:
		screen_history[0].transition_open_immediately()
		
	

func pop_screen():
	if screen_history.size() < 2:
		D.e(D.LogCategory.SCREEN_MANAGER, ["Tried popping Screen, but the screen_history buffer would have been empty"])
		return
	
	var show_transition = screen_history[1].show_transition_on_enter or screen_history[0].show_transition_on_leave
	
	if show_transition:
		screen_history[0].transition_close()
		yield(screen_history[0], "on_transition_closed")
		
	___exit_screen()

	
	var last_screen = screen_history.pop_front()
	last_screen.queue_free()
	
	___enter_screen(screen_history[0])
		
	if show_transition:
		screen_history[0].transition_open()
		yield(screen_history[0], "on_transition_opened")
	else:
		screen_history[0].transition_open_immediately()
		

func exit_game():
	get_tree().quit()
