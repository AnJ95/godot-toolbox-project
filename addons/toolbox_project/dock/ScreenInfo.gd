tool
extends VBoxContainer

var dock
var ei:EditorInterface
var gui:Control
var pretty_name:String
var path_from:String
var path_to:String

onready var iconExists = $DoesExist/Icon
onready var label = $DoesExist/Label
onready var btnCreate = $Btns/Create
onready var btnOpen = $Btns/Open
onready var btnReset = $Btns/Reset

var is_inited = false

func init_gui(dock, pretty_name, path_from, path_to):
	self.dock = dock
	self.ei = dock.ei
	self.gui = dock.gui
	self.pretty_name = pretty_name
	self.path_from = path_from
	self.path_to = path_to
	is_inited = true
	
func _ready():
	label.text = pretty_name
	if is_inited:
		update_ui()
	
func update_ui():
	var exists = File.new().file_exists(path_to)
	
	btnCreate.disabled = exists
	btnOpen.disabled = !exists
	btnReset.disabled = !exists
	
	if gui:
		iconExists.texture = gui.get_icon("StatusSuccess" if exists else "StatusError", "EditorIcons")
	else:
		iconExists.texture = null
	
	
func _on_Create_pressed():
	if is_inited:
		dock.copy_default_file(path_from, path_to, btnCreate)


func _on_Open_pressed():
	if is_inited:
		ei.select_file(path_to)
		dock.open_or_reload_scene(path_to)
		dock.set_main_screen_and_await("2D")

func _on_Reset_pressed():
	if is_inited:
		dock.copy_default_file(path_from, path_to, btnReset, true)
