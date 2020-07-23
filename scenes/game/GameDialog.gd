extends CanvasLayer

onready var menu = $Popup
onready var invisible_wall = $InvisibleWall

export var pauses_game_while_open = false
export var signal_to_open_to = "level_lost"
export var can_open_and_close = false

export var can_be_exited_by_pressing_escape = false
export var can_be_exited_by_clicking_elsewhere = false

var is_open = false

func _ready():
	if can_open_and_close:
		SignalMngr.connect(signal_to_open_to, self, "_on_open_or_close")
	else:
		SignalMngr.connect(signal_to_open_to, self, "_on_open")
	
	SignalMngr.connect("level_started", self, "_on_level_started")

func _on_level_started(_level):
	__hide()
	
func _process(delta):
	if pauses_game_while_open and Input.is_action_just_pressed("Pause"):
		SignalMngr.emit_signal("game_paused", !is_open)
		
	if can_be_exited_by_pressing_escape and is_open and Input.is_action_just_pressed("ui_cancel"):
		_on_BtnResume_pressed()

func _on_open():
	__show()
		
func _on_open_or_close(open):
	__show(open)
	
func __show(show=true):
	is_open = show
	invisible_wall.mouse_filter = invisible_wall.MOUSE_FILTER_STOP if is_open else invisible_wall.MOUSE_FILTER_IGNORE
	if is_open:
		menu.popup_centered()
	else:
		menu.visible = false
	invisible_wall.visible = is_open
	
	if pauses_game_while_open:
		get_tree().paused = is_open

func __hide():
	__show(false)

func _on_InvisibleWall_pressed():
	if can_be_exited_by_clicking_elsewhere:
		_on_BtnResume_pressed()

func _on_BtnResume_pressed():
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

