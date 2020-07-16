extends Camera2D

var demos = []
var cur_demo_id = 0

func _ready():
	demos = get_tree().get_nodes_in_group("TileMapDemo")
	
	cur_demo_id = 0
	open_demo(demos[cur_demo_id])

func open_demo(demo):
	var rect = demo.get_map_rect()
	
	# Get the canvas transform and Viewport
	var ctrans = get_canvas_transform()
	var vp_pos = -ctrans.get_origin() / ctrans.get_scale()
	var vp_size = get_viewport_rect().size / ctrans.get_scale()
	var vp:Rect2 = Rect2(vp_pos, vp_size)
	
	print("#############")
	print(demo.name)
	print(rect)
	print(vp)
	
	
	zoom = rect.size / get_viewport_rect().size#vp_size
	offset = rect.position + rect.size / 2
	
	
func _process(delta):
	
	if Input.is_action_just_pressed("PrevDemo"):
		print("PREV")
		cur_demo_id = max(cur_demo_id-1, 0)
		open_demo(demos[cur_demo_id])
	if Input.is_action_just_pressed("NextDemo"):
		print("NEXT")
		cur_demo_id = min(cur_demo_id+1, demos.size()-1)
		open_demo(demos[cur_demo_id])
	
