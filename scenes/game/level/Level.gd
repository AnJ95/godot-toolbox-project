extends Node2D

onready var ref_rect:ReferenceRect = $ReferenceRect
onready var start_pos:Vector2 = $StartPoint.global_position

const LevelCamera = preload("res://scenes/game/level/LevelCamera.gd")
const Player = preload("res://scenes/entities/Player.gd")

export(LevelCamera.CameraType) var camera_type = LevelCamera.CameraType.Static
export(Vector2) var camera_zoom = Vector2(1,1)
export(Vector2) var camera_position = Vector2(0,0)

export(Player.ControlScheme) var control_scheme = Player.ControlScheme.Platformer
export(bool) var give_player_light = false
export(Vector2) var gravity = Vector2(0, 500)

func _ready():
	add_to_group("Level")
	SignalMngr.connect("level_started", self, "_on_level_started")	

func _on_level_started(level):
	visible = self == level
	
	if self == level:
		D.l("Level", ["Level started [", {
			"name" : level.name,
			"map_rect" : get_map_rect(),
			"player_start_pos" : get_player_start_pos(),
			"camera_type" : LevelCamera.CameraType.keys()[camera_type()],
			"control_scheme" : Player.ControlScheme.keys()[get_control_scheme()], 
		} , "]"])
		

func get_map_rect()->Rect2:
	var rect_pos = ref_rect.rect_global_position
	var rect_size = ref_rect.rect_size
	return Rect2(rect_pos, rect_size)

func get_player_start_pos()->Vector2:
	return start_pos
	
func camera_type():
	return camera_type

func get_control_scheme():
	return control_scheme

func give_player_light():
	return give_player_light
