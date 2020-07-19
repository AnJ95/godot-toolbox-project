extends CanvasLayer

onready var ui_box = $UIBox
onready var pause_menu = $UIBox/Popup
onready var invisible_wall = $InvisibleWall

var is_paused = false

func _ready():
	_on_game_paused(false)
	SignalMngr.connect("game_paused", self, "_on_game_paused")

func _on_game_paused(pause_on):
	is_paused = pause_on
	if is_paused:
		__show()
	else:
		__hide()
	
	get_tree().paused = pause_on

func __show():
	ui_box.mouse_filter = pause_menu.MOUSE_FILTER_STOP
	invisible_wall.mouse_filter = invisible_wall.MOUSE_FILTER_STOP
	ui_box.visible = true
	pause_menu.visible = true
	invisible_wall.visible = true
func __hide():
	ui_box.mouse_filter = pause_menu.MOUSE_FILTER_IGNORE
	invisible_wall.mouse_filter = invisible_wall.MOUSE_FILTER_IGNORE
	ui_box.visible = false
	pause_menu.visible = false
	invisible_wall.visible = false
	
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		SignalMngr.emit_signal("game_paused", !is_paused)
		
	if is_paused and Input.is_action_just_pressed("ui_cancel"):
		_on_ReturnButton_pressed()

func _on_ReturnButton_pressed():
	SignalMngr.emit_signal("game_paused", false)
	
func _on_RestartLevelButton_pressed():
	__hide()
	SignalMngr.emit_signal("level_restarted")

func _on_MenuButton_pressed():
	SignalMngr.emit_signal("game_paused", false)
	# TODO: Confirm PopUp
	ScreenMngr.pop_screen()

func _on_QuitButton_pressed():
	SignalMngr.emit_signal("game_paused", false)
	# TODO: Confirm PopUp
	ScreenMngr.exit_game()

func _on_InvisibleWall_pressed():
	if is_paused:
		_on_ReturnButton_pressed()


