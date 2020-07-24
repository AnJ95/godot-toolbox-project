extends CanvasLayer

onready var tween = $Tween
onready var wing_left = $WingLeft
onready var wing_right = $WingRight

const DURATION = 0.5
const TRANS = Tween.TRANS_EXPO
const EASE = Tween.EASE_OUT

func _ready():
	wing_left.visible = true
	wing_right.visible = true

func open_immediately():
	if !wing_left: wing_left = $WingLeft
	if !wing_right: wing_right = $WingRight
	wing_left.anchor_right = 0
	wing_right.anchor_left = 1

func close():
	tween.interpolate_property(wing_left, "anchor_right", 0, 0.5, DURATION, TRANS, EASE)
	tween.interpolate_property(wing_right, "anchor_left", 1, 0.5, DURATION, TRANS, EASE)
	tween.connect("tween_all_completed", self, "_on_closed", [], Tween.CONNECT_ONESHOT)
	tween.start()

func open():
	tween.interpolate_property(wing_left, "anchor_right", 0.5, 0, DURATION, TRANS, EASE)
	tween.interpolate_property(wing_right, "anchor_left", 0.5, 1, DURATION, TRANS, EASE)
	tween.connect("tween_all_completed", self, "_on_opened", [], Tween.CONNECT_ONESHOT)
	tween.start()
	
func _on_closed():
	get_parent().emit_signal("on_transition_closed")
	
func _on_opened():
	get_parent().emit_signal("on_transition_opened")
