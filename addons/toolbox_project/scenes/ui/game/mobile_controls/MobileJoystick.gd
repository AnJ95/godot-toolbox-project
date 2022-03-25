tool
extends "MobileControl.gd"


#############################################################
# CUSTOMIZATION


export var left_allow = true
export var left_action = "left"
export var left_analog = true
export var left_digital_threshold = 0.2

export var up_allow = true
export var up_action = "up"
export var up_analog = true
export var up_digital_threshold = 0.2

export var right_allow = true
export var right_action = "right"
export var right_analog = true
export var right_digital_threshold = 0.2

export var down_allow = true
export var down_action = "down"
export var down_analog = true
export var down_digital_threshold = 0.2


#############################################################
# STATE
var current_control = Vector2.ZERO

#############################################################
# NODES
onready var knob = $Knob

#############################################################
# LIFECYLE


#############################################################
# HANDLERS
func _on_touch():
	pass

func _on_untouch():
	set_current_control(Vector2.ZERO)

func _on_touch_move(global_pos:Vector2):
	# mouse pos relative to top left corner
	var pos = global_pos - rect_global_position
	# mouse pos relative to center
	pos.x -= _cache_half_size
	pos.y -= _cache_half_size
	# normalized Vector2([-1,1], [-1,1])
	pos = pos / _cache_half_size
	# normalized and length <= 1
	var pos_len = pos.length()
	if pos_len > 1: pos = pos / pos_len
	
	set_current_control(pos)
		
func set_current_control(control):
	current_control = control
	knob.rect_position = current_control * _cache_half_size
	
func _physics_process(delta):
	process_control(left_action, left_allow, left_analog, -current_control.x, left_digital_threshold)
	process_control(up_action, up_allow, up_analog, -current_control.y, up_digital_threshold)
	process_control(right_action, right_allow, right_analog, current_control.x, right_digital_threshold)
	process_control(down_action, down_allow, down_analog, current_control.y, down_digital_threshold)

var currently_pressed = []
func process_control(action, allow, analog, current, digital_threshold):
	if allow and ((analog and current > 0) or (!analog and current > digital_threshold)):
		Input.action_press(action, current if analog else 1.0)
		if not action in currently_pressed:
			currently_pressed.append(action)
	elif action in currently_pressed:
		currently_pressed.erase(action)
		Input.action_release(action)


		
