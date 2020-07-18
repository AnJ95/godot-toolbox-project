extends CanvasLayer

onready var ui_box = $UIBox
onready var game_over_menu = $UIBox/Popup
onready var invisible_wall = $InvisibleWall

var is_game_over = false

func _ready():
	Sgn.connect("player_died", self, "_on_player_died")
	__hide()

func _on_player_died():
	__show()
	is_game_over = true
func __show():
	ui_box.mouse_filter = ui_box.MOUSE_FILTER_STOP
	invisible_wall.mouse_filter = invisible_wall.MOUSE_FILTER_STOP
	game_over_menu.visible = true
	ui_box.visible = true
	invisible_wall.visible = true
func __hide():
	ui_box.mouse_filter = ui_box.MOUSE_FILTER_IGNORE
	invisible_wall.mouse_filter = game_over_menu.MOUSE_FILTER_IGNORE
	game_over_menu.visible = false
	ui_box.visible = false
	invisible_wall.visible = false

func _process(delta):
	if is_game_over and Input.is_action_just_pressed("ui_cancel"):
		_on_MenuButton_pressed()

func _on_MenuButton_pressed():
	ScrnMngr.pop_screen()

func _on_RestartLevelButton_pressed():
	__hide()
	Sgn.emit_signal("level_restarted")

func _on_RestartGameButton_pressed():
	__hide()
	Sgn.emit_signal("game_ended")
	ScrnMngr.reload_screen()

func _on_InvisibleWall_pressed():
	pass
