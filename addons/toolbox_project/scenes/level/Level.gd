extends Node2D

#############################################################
# NODES
onready var ref_rect:ReferenceRect = $ReferenceRect
onready var start_pos:Vector2 = $StartPoint.global_position
onready var audioStreamPlayer:AudioStreamPlayer = $AudioStreamPlayer

#############################################################
# CONSTANTS
const LevelCamera = preload("LevelCamera.gd")

#############################################################
# CUSTOMIZATION
# Camera
export(LevelCamera.CameraType) var camera_type = LevelCamera.CameraType.Static
export(Vector2) var camera_zoom = Vector2(1,1)
export(Vector2) var camera_position = Vector2(0,0)

# Player
export(int) var control_scheme = 0
export(bool) var give_player_light = false
export(String) var player_root_node = null

# Global
export(Vector2) var gravity = Vector2(0, 500)

# Sound
export(Resource) var soundtrack = null

#############################################################
# STATE
onready var num_coins = get_tree().get_nodes_in_group("PickupCoin").size()

func _ready():
	StateMngr.score.connect("state_changed", self, "_on_score_changed")
	audioStreamPlayer.stream = soundtrack if soundtrack else C.DEFAULT_LEVEL_SONG
	audioStreamPlayer.play()

func _on_score_changed(score):
	if score >= num_coins:
		SignalMngr.emit_signal("level_won")

#############################################################
# AUDIO
var playback_position = 0
func pause_soundtrack(pause=true):
	if pause:
		playback_position = audioStreamPlayer.get_playback_position()
		audioStreamPlayer.stop()
	else:
		audioStreamPlayer.play(playback_position)
		
func quiet_soundtrack(quiet=true):
	audioStreamPlayer.volume_db = -15 if quiet else 0

#############################################################
# LEVEL-SPECIFIC GETTER
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

func get_player_root_node():
	if player_root_node == null:
		return self
	else:
		return get_node(player_root_node)
