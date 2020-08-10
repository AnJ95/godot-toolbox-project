tool
extends EditorPlugin

const BASE_PATH = "res://addons/toolbox_project/"
const AUTOLOADS_PATH = BASE_PATH + "autoloads/"

const Icon = preload("res://addons/toolbox_project/assets/logo/logo32.png")

const Dock = preload("res://addons/toolbox_project/dock/Dock.tscn")
const DockScript = preload("res://addons/toolbox_project/dock/Dock.gd")
var dock

var dock_btn_create_screenGame:Button
var dock_btn_create_config:Button
var dock_btn_reset_screenGame:Button
var dock_btn_reset_config:Button
var dock_btn_open_screenGame:Button
var dock_btn_open_config:Button

var dock_btn_set_busLayout:Button
	
var dock_checkbox_screenGame:CheckBox
var dock_checkbox_config:CheckBox

const PATH_SCREENGAME = "res://ScreenGame.tscn"
const PATH_SCREENGAME_DEFAULT = "res://addons/toolbox_project/defaults/ScreenGame.tscn"
const PATH_CONFIG = "res://toolbox_project_settings.cfg"
const PATH_CONFIG_DEFAULT = "res://addons/toolbox_project/defaults/toolbox_project_settings.cfg"

const PATH_THEME = "res://addons/toolbox_project/assets/theme.tres"
const PATH_THEME_TESTER = "res://addons/toolbox_project/scenes/ui/ThemeTester.tscn"

const PATH_BUSLAYOUT = "res://addons/toolbox_project/bus_layout.tres"

const autoloads = {
	"C":				BASE_PATH + "Config.gd",
	"D":				AUTOLOADS_PATH + "Debug.gd",
	"ScreenMngr":		AUTOLOADS_PATH + "ScreenMngr.gd",
	"StateMngr":		AUTOLOADS_PATH + "StateMngr.gd",
	"SignalMngr":		AUTOLOADS_PATH + "SignalMngr.gd",
	"PersistenceMngr":AUTOLOADS_PATH + "PersistenceMngr.gd",
	"SoundMngr":		AUTOLOADS_PATH + "SoundMngr.gd",
	"ControlMngr":	AUTOLOADS_PATH + "ControlMngr.gd"
}


func _enter_tree():
	for key in autoloads.keys():
		add_autoload_singleton(key, autoloads[key])

	# Add the loaded scene to the docks.
	dock = create_dock()
	add_control_to_bottom_panel(dock, "ToolboxProject")


	# Print Getting Started
	print(get_description())

func create_dock():
	var dock = Dock.instance()
	dock_btn_create_screenGame = dock.get_node("VBoxContainer/ScreenGameCreate")
	dock_btn_open_screenGame = dock.get_node("VBoxContainer/ScreenGameOpen")
	dock_btn_reset_screenGame = dock.get_node("VBoxContainer/ScreenGameReset")
	
	dock_btn_create_config = dock.get_node("VBoxContainer2/ConfigCreate")
	dock_btn_open_config = dock.get_node("VBoxContainer2/ConfigOpen")
	dock_btn_reset_config = dock.get_node("VBoxContainer2/ConfigReset")
	
	dock_btn_set_busLayout = dock.get_node("VBoxContainer4/SetBusLayout")
	
	dock_checkbox_screenGame = dock.get_node("VBoxContainer/CheckBox")
	dock_checkbox_config = dock.get_node("VBoxContainer2/CheckBox")
	
	dock_btn_create_screenGame.connect("pressed", self, "on_create_file_pressed", [
		"ScreenGame.tscn", PATH_SCREENGAME_DEFAULT, PATH_SCREENGAME, dock_btn_create_screenGame])
	dock_btn_open_screenGame.connect("pressed", self, "on_open_screenGame_pressed")
	dock_btn_reset_screenGame.connect("pressed", self, "on_create_file_pressed", [
		"ScreenGame.tscn", PATH_SCREENGAME_DEFAULT, PATH_SCREENGAME, dock_btn_reset_screenGame, true])
	
	dock_btn_create_config.connect("pressed", self, "on_create_file_pressed", [
		"toolbox_project_settings.cfg", PATH_CONFIG_DEFAULT, PATH_CONFIG, dock_btn_create_config])
	dock_btn_open_config.connect("pressed", self, "on_open_config_pressed")
	dock_btn_reset_config.connect("pressed", self, "on_create_file_pressed", [
		"toolbox_project_settings.cfg", PATH_CONFIG_DEFAULT, PATH_CONFIG, dock_btn_reset_config, true])
	
	dock.get_node("VBoxContainer3/ShowTheme").connect("pressed", self, "on_show_theme_pressed")
	
	dock_btn_set_busLayout.connect("pressed", self, "on_set_busLayout_pressed")
	dock.get_node("VBoxContainer4/ShowBusLayout").connect("pressed", self, "on_show_busLayout_pressed")
	
	update_dock()
	return dock

func update_dock():
	var f = File.new()
	var does_screenGame_exist = f.file_exists(PATH_SCREENGAME)
	var does_config_exist = f.file_exists(PATH_CONFIG)
	var is_busLayout_set = ProjectSettings.get("audio/default_bus_layout") == PATH_BUSLAYOUT
	
	dock_checkbox_screenGame.pressed = does_screenGame_exist
	dock_btn_create_screenGame.disabled = does_screenGame_exist
	dock_btn_open_screenGame.disabled = !does_screenGame_exist
	dock_btn_reset_screenGame.disabled = !does_screenGame_exist
	
	dock_checkbox_config.pressed = does_config_exist
	dock_btn_create_config.disabled = does_config_exist
	dock_btn_open_config.disabled = !does_config_exist
	dock_btn_reset_config.disabled = !does_config_exist
	dock_btn_reset_config.disabled = !does_config_exist
	
	dock_btn_set_busLayout.disabled = is_busLayout_set
	
func on_create_file_pressed(filename, path_from, path_to, btn, accept=false):
	if accept:
		var dialog = ConfirmationDialog.new()
		dialog.window_title = "Reset " + filename + "?"
		dialog.dialog_text = "Are you sure to reset? This will delete the current " + filename + "."
		get_editor_interface().get_base_control().add_child(dialog)
		dialog.popup_centered_minsize()
		if dialog.is_connected("confirmed", self, "on_create_file_pressed"):
			dialog.disconnect("confirmed", self, "on_create_file_pressed")
		dialog.connect("confirmed", self, "on_create_file_pressed", [filename, path_from, path_to, btn], CONNECT_ONESHOT)
		return
		
	var dir = Directory.new()
	if OK != dir.copy(path_from, path_to):
		var prev_text = btn.text
		btn.text = "Error"
		yield(get_tree().create_timer(1), "timeout")
		btn.text = prev_text
	else:
		if path_to.ends_with(".tscn"):
			var ei = get_editor_interface()
			ei.open_scene_from_path(path_to)
			ei.reload_scene_from_path(path_to)
			ei.select_file(path_to)
			ei.set_main_screen_editor("2D")
		else:
			OS.shell_open("file://" + ProjectSettings.globalize_path(path_to))
		
		update_dock()

func on_open_screenGame_pressed():
	var ei = get_editor_interface()
	ei.select_file(PATH_SCREENGAME)
	ei.open_scene_from_path(PATH_SCREENGAME)
	ei.set_main_screen_editor("2D")
	
func on_open_config_pressed():
	var ei = get_editor_interface()
	ei.select_file(PATH_CONFIG)
	OS.shell_open("file://" + ProjectSettings.globalize_path(PATH_CONFIG))

func on_show_theme_pressed():
	var ei = get_editor_interface()
	ei.select_file(PATH_THEME)
	ei.open_scene_from_path(PATH_THEME_TESTER)
	ei.set_main_screen_editor("2D")
	ei.edit_resource(preload(PATH_THEME))
	
func on_show_busLayout_pressed():
	var ei = get_editor_interface()
	ei.select_file(PATH_BUSLAYOUT)
	ei.edit_resource(preload(PATH_BUSLAYOUT))

func on_set_busLayout_pressed():
	ProjectSettings.set("audio/default_bus_layout", PATH_BUSLAYOUT)
	update_dock()
	
#func get_plugin_icon():
	#return Icon

func _exit_tree():
	for key in autoloads.keys():
		remove_autoload_singleton(key)

	remove_control_from_bottom_panel(dock)
	dock.free()

var timer = 0
func _process(delta):
	timer += delta
	if timer > 5:
		timer = 0
		update_dock()
		#print(get_description())

func get_description():
	var d = ""
	d += "##########################################\n"
	d += "## TOOLBOX PROJECT                      ##\n"
	d += "##########################################\n"

	d += "# Getting started\n"
	d += "## Add you game\n"
	d += "To insert your game into the menu structure, you need to register a root scene for you game inheriting Screen.\n"
	d += "The easiest way to do so is to inherit \"res://addons/toolbox_project/scenes/screens/ScreenGame.tscn\" and save it in your games root directory as \"res://ScreenGame.tscn\"."
	d += "Your ScreenGame now supplies custumizable game ui elements, game diaglos for pausing and more.\n"
	d += "Make sure your game root is instantiated into this scene."

	d += "## Add a config file\n"

	d += "Checklist\n"

	d += "##########################################\n"
	return d;
