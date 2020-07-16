extends CanvasLayer

onready var pause_menu = $UIBox

func _ready():
	_set_visible(false)

func _on_game_paused(pause_on):
	_set_visible(pause_on)

func _set_visible(visible):
	pause_menu.visible = visible
