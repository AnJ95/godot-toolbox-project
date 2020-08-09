extends CanvasLayer

#############################################################
# NODES
onready var root = $CenterContainer
onready var root_btns = $CenterContainer/Popup/VBoxContainer
onready var invisible_wall = $InvisibleWall
onready var audioStreamPlayer:AudioStreamPlayer = $AudioStreamPlayer

#############################################################
# CUSTOMIZATION
export(String) var config_dialog_song = "DIALOG_PAUSE_SONG"
onready var soundtrack_or_null = C.get(config_dialog_song)

export var toggled_by_pause_action = false
export var pauses_game_while_open = false
export var signal_to_open_to = "level_lost"
export var can_open_and_close = false

export var can_be_exited_by_pressing_escape = false
export var can_be_exited_by_clicking_elsewhere = false

#############################################################
# STATE
var is_open = false
var level

#############################################################
# LIFECYCLE
func _ready():
	if can_open_and_close:
		SignalMngr.connect(signal_to_open_to, self, "_on_open_or_close")
	else:
		SignalMngr.connect(signal_to_open_to, self, "_on_open")
	
	SignalMngr.connect("level_started", self, "_on_level_started")
	
	if soundtrack_or_null:
		audioStreamPlayer.stream = soundtrack_or_null
	
func _process(delta):
	if can_be_exited_by_pressing_escape and is_open and Input.is_action_just_pressed("ui_cancel"):
		_on_BtnResume_pressed()
	if toggled_by_pause_action and Input.is_action_just_pressed("game_pause"):
		__show(!is_open)

#############################################################
# OPENING & CLOSING
func _on_level_started(level):
	self.level = level
	__hide()
	
func _on_open():
	__show()
		
func _on_open_or_close(open):
	__show(open)
	
func __show(show=true):
	is_open = show
	invisible_wall.mouse_filter = invisible_wall.MOUSE_FILTER_STOP if is_open else invisible_wall.MOUSE_FILTER_IGNORE
	root.visible = is_open
	
	if soundtrack_or_null:
		if level: level.pause_soundtrack(is_open)
		if is_open:	audioStreamPlayer.play(0)
		else:		audioStreamPlayer.stop()
	elif level:
		level.quiet_soundtrack(is_open)
	
	invisible_wall.visible = is_open
	
	if pauses_game_while_open:
		get_tree().paused = is_open
		
	if show:
		for btn in root_btns.get_children():
			if btn is Button and btn.visible:
				btn.grab_focus()
				break

func __hide():
	__show(false)

#############################################################
# BUTTON HANDLERS

func _on_InvisibleWall_pressed():
	if can_be_exited_by_clicking_elsewhere:
		_on_BtnResume_pressed()

func _on_BtnResume_pressed():
	SoundMngr.play_ui_sound(C.UI_SELECT)
	if can_open_and_close:
		SignalMngr.emit_signal(signal_to_open_to, false)
	else:
		__hide()

func _on_BtnRetry_pressed():
	_on_BtnResume_pressed()
	SignalMngr.emit_signal("restart_level")

func _on_BtnNext_pressed():
	_on_BtnResume_pressed()
	SignalMngr.emit_signal("next_level")

func _on_BtnMenu_pressed():
	_on_BtnResume_pressed()
	ScreenMngr.pop_screen()

func _on_BtnQuit_pressed():
	_on_BtnResume_pressed()
	ScreenMngr.exit_game()

func _on_BtnSettings_pressed():
	_on_BtnResume_pressed()
	ScreenMngr.push_screen(C.SCREEN_OPTIONS_MENU)
