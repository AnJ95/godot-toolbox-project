tool
extends EditorPlugin

const BASE_PATH = "res://addons/toolbox_project/"
const AUTOLOADS_PATH = BASE_PATH + "autoloads/"

const Icon = preload("res://addons/toolbox_project/assets/logo/logo32.png")

const Dock = preload("res://addons/toolbox_project/dock/Dock.tscn")
var dock

var dock_btn_create_screenGame:Button
var dock_btn_create_config:Button
var dock_btn_reset_screenGame:Button
var dock_btn_reset_config:Button
var dock_btn_open_screenGame:Button
var dock_btn_show_all_screens:Button
var dock_btn_open_config:Button

var dock_btn_set_busLayout:Button
var dock_btn_show_busLayout:Button

var dock_icon_does_screenGame_exist:TextureRect
var dock_label_does_screenGame_exist:Label

var dock_icon_does_config_exist:TextureRect
var dock_label_does_config_exist:Label

var dock_icon_is_busLayout_set:TextureRect
var dock_label_is_busLayout_set:Label

var dock_btn_open_theme:Button

var dock_btn_open_projectInputMap:Button
var dock_btn_open_controlSettingsMenu:Button
var dock_btn_delete_controlSetting:Button

var dock_btn_show_saveDir:Button
var dock_btn_delete_saves:Button


const PATH_SCREENGAME = "res://ScreenGame.tscn"
const PATH_SCREENGAME_DEFAULT = "res://addons/toolbox_project/defaults/ScreenGame.tscn"
const PATH_CONFIG = "res://toolbox_project.cfg"
const PATH_CONFIG_DEFAULT = "res://addons/toolbox_project/defaults/toolbox_project.cfg"

const PATH_SCREENS = "res://addons/toolbox_project/scenes/screens/Screen.tscn"

const PATH_THEME = "res://addons/toolbox_project/assets/theme.tres"
const PATH_THEME_TESTER = "res://addons/toolbox_project/scenes/ui/ThemeTester.tscn"

const PATH_BUSLAYOUT = "res://addons/toolbox_project/bus_layout.tres"

const PATH_CONTROLSETTINGSMENU = "res://addons/toolbox_project/scenes/ui/menu/controls/ControlMenu.tscn"
const PATH_SAVES = "user://"
const PATH_CONTROLSETTINGS = "user://save_settingsControls.save"

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
	
	# Get sub nodes
	dock_btn_create_screenGame = dock.get_node("VBoxContainer/ScreenGameCreate")
	dock_btn_open_screenGame = dock.get_node("VBoxContainer/ScreenGameOpen")
	dock_btn_reset_screenGame = dock.get_node("VBoxContainer/ScreenGameReset")
	dock_btn_show_all_screens = dock.get_node("VBoxContainer/ShowAllScreens")
	
	dock_btn_create_config = dock.get_node("VBoxContainer2/ConfigCreate")
	dock_btn_open_config = dock.get_node("VBoxContainer2/ConfigOpen")
	dock_btn_reset_config = dock.get_node("VBoxContainer2/ConfigReset")
	
	dock_btn_set_busLayout = dock.get_node("VBoxContainer4/SetBusLayout")
	dock_btn_show_busLayout = dock.get_node("VBoxContainer4/ShowBusLayout")
	
	dock_btn_open_theme = dock.get_node("VBoxContainer3/ShowTheme")
	
	dock_icon_does_screenGame_exist = dock.get_node("VBoxContainer/DoesScreenGameExist/Icon")
	dock_label_does_screenGame_exist = dock.get_node("VBoxContainer/DoesScreenGameExist/Label")
	dock_icon_does_config_exist = dock.get_node("VBoxContainer2/DoesConfigExist/Icon")
	dock_label_does_config_exist = dock.get_node("VBoxContainer2/DoesConfigExist/Label")
	dock_icon_is_busLayout_set = dock.get_node("VBoxContainer4/IsBusLayoutSet/Icon")
	dock_label_is_busLayout_set = dock.get_node("VBoxContainer4/IsBusLayoutSet/Label")
	
	dock_btn_open_projectInputMap = dock.get_node("VBoxContainer5/OpenProjectInputMap")
	dock_btn_open_controlSettingsMenu = dock.get_node("VBoxContainer5/OpenControlSettingsMenu")
	dock_btn_delete_controlSetting = dock.get_node("VBoxContainer5/DeleteControlSettings")
	
	dock_btn_show_saveDir = dock.get_node("VBoxContainer6/ShowSaveDir")
	dock_btn_delete_saves = dock.get_node("VBoxContainer6/DeleteSaves")
	
	# Set Icons
	var gui = get_editor_interface().get_base_control()
	dock_btn_create_config.icon = gui.get_icon("New", "EditorIcons")
	dock_btn_create_screenGame.icon = gui.get_icon("CreateNewSceneFrom", "EditorIcons")
	
	dock_btn_reset_config.icon = gui.get_icon("Loop", "EditorIcons")
	dock_btn_reset_screenGame.icon = gui.get_icon("Loop", "EditorIcons")
	
	dock_btn_open_screenGame.icon = gui.get_icon("PackedScene", "EditorIcons")
	dock_btn_open_config.icon = gui.get_icon("Load", "EditorIcons")
	
	dock_btn_show_all_screens.icon = gui.get_icon("Load", "EditorIcons")
	
	dock_btn_open_theme.icon = gui.get_icon("Theme", "EditﬂﬂorIcons")
	
	dock_btn_set_busLayout.icon = gui.get_icon("AudioBusLayout", "EditorIcons")
	dock_btn_show_busLayout.icon = gui.get_icon("AudioBusLayout", "EditorIcons")
	
	dock_btn_open_projectInputMap.icon = gui.get_icon("Joypad", "EditorIcons")
	dock_btn_open_controlSettingsMenu.icon = gui.get_icon("PackedScene", "EditorIcons")
	dock_btn_delete_controlSetting.icon = gui.get_icon("Remove", "EditorIcons")
	
	dock_btn_show_saveDir.icon = gui.get_icon("Load", "EditorIcons")
	dock_btn_delete_saves.icon = gui.get_icon("Remove", "EditorIcons")
	
	# Connect button signals
	dock_btn_create_screenGame.connect("pressed", self, "on_create_file_pressed", [
		"ScreenGame.tscn", PATH_SCREENGAME_DEFAULT, PATH_SCREENGAME, dock_btn_create_screenGame])
	dock_btn_open_screenGame.connect("pressed", self, "on_open_screenGame_pressed")
	dock_btn_show_all_screens.connect("pressed", self, "on_show_all_screens_pressed")
	dock_btn_reset_screenGame.connect("pressed", self, "on_create_file_pressed", [
		"ScreenGame.tscn", PATH_SCREENGAME_DEFAULT, PATH_SCREENGAME, dock_btn_reset_screenGame, true])
	
	dock_btn_create_config.connect("pressed", self, "on_create_file_pressed", [
		PATH_CONFIG_DEFAULT, PATH_CONFIG, dock_btn_create_config])
	dock_btn_open_config.connect("pressed", self, "on_open_config_pressed")
	dock_btn_reset_config.connect("pressed", self, "on_create_file_pressed", [
		PATH_CONFIG_DEFAULT, PATH_CONFIG, dock_btn_reset_config, true])
	
	dock_btn_open_theme.connect("pressed", self, "on_show_theme_pressed")
	
	dock_btn_set_busLayout.connect("pressed", self, "on_set_busLayout_pressed")
	dock_btn_show_busLayout.connect("pressed", self, "on_show_busLayout_pressed")
	
	dock_btn_open_projectInputMap.connect("pressed", self, "on_open_projectInputMap_pressed")
	dock_btn_open_controlSettingsMenu.connect("pressed", self, "on_open_controlSettingsMenu_pressed")
	dock_btn_delete_controlSetting.connect("pressed", self, "on_delete_controlSettings_pressed", [true])
	
	dock_btn_show_saveDir.connect("pressed", self, "on_show_saveDir_pressed")
	dock_btn_delete_saves.connect("pressed", self, "on_delete_saves_pressed", [true])
	
	dock.get_node("CenterContainer/VBoxContainer/OpenGithub").connect("pressed", self, "on_open_github_pressed")
	
	update_dock()
	return dock

func update_dock():
	
	
	var f = File.new()
	var does_screenGame_exist = f.file_exists(PATH_SCREENGAME)
	var does_config_exist = f.file_exists(PATH_CONFIG)
	var is_busLayout_set = ProjectSettings.get("audio/default_bus_layout") == PATH_BUSLAYOUT
	
	dock_btn_create_screenGame.disabled = does_screenGame_exist
	dock_btn_open_screenGame.disabled = !does_screenGame_exist
	dock_btn_reset_screenGame.disabled = !does_screenGame_exist
	
	dock_btn_create_config.disabled = does_config_exist
	dock_btn_open_config.disabled = !does_config_exist
	dock_btn_reset_config.disabled = !does_config_exist
	dock_btn_reset_config.disabled = !does_config_exist
	
	dock_btn_set_busLayout.disabled = is_busLayout_set
	
	
	var gui = get_editor_interface().get_base_control()
	dock_icon_does_screenGame_exist.texture = gui.get_icon("StatusSuccess" if does_screenGame_exist else "StatusError", "EditorIcons")
	dock_label_does_screenGame_exist.text = PATH_SCREENGAME# + (" exists" if does_screenGame_exist else " does not exist!")
	
	dock_icon_does_config_exist.texture = gui.get_icon("StatusSuccess" if does_config_exist else "StatusError", "EditorIcons")
	dock_label_does_config_exist.text = PATH_CONFIG# + (" exists" if does_config_exist else " does not exist!")
	
	dock_icon_is_busLayout_set.texture = gui.get_icon("StatusSuccess" if is_busLayout_set else "StatusError", "EditorIcons")
	dock_label_is_busLayout_set.text = "BusLayout" + (" is set" if is_busLayout_set else " is not set!")
	

func show_confirm_dialog(title, text, then_emit, then_binds):
	var dialog = ConfirmationDialog.new()
	dialog.window_title = title
	dialog.dialog_text = text
	get_editor_interface().get_base_control().add_child(dialog)
	dialog.popup_centered_minsize()
	if dialog.is_connected("confirmed", self, then_emit):
		dialog.disconnect("confirmed", self, then_emit)
	dialog.connect("confirmed", self, then_emit, then_binds, CONNECT_ONESHOT)
	
func on_create_file_pressed(path_from, path_to, btn, accept=false):
	if accept:
		show_confirm_dialog(
			"Reset " + path_to + "?",
			"Are you sure to reset? This will delete the current " + path_to + ".",
			"on_create_file_pressed",
			[path_from, path_to, btn]
		)
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

func on_show_all_screens_pressed():
	var ei = get_editor_interface()
	ei.select_file(PATH_SCREENS)
	
func on_open_config_pressed():
	var ei = get_editor_interface()
	ei.select_file(PATH_CONFIG)
	OS.shell_open("file://" + ProjectSettings.globalize_path(PATH_CONFIG))

func on_show_theme_pressed():
	var ei = get_editor_interface()
	
	var prev_open = PATH_THEME_TESTER in ei.get_open_scenes()
	
	ei.open_scene_from_path(PATH_THEME_TESTER)
	if !prev_open: yield(self, "scene_changed")
	ei.set_main_screen_editor("2D")
	
	ei.select_file(PATH_THEME)
	ei.edit_resource(preload(PATH_THEME))
	
func on_show_busLayout_pressed():
	var ei = get_editor_interface()
	ei.select_file(PATH_BUSLAYOUT)
	ei.edit_resource(preload(PATH_BUSLAYOUT))

func on_set_busLayout_pressed():
	ProjectSettings.set("audio/default_bus_layout", PATH_BUSLAYOUT)
	update_dock()

func on_open_projectInputMap_pressed():
  print("NOT IMPLEMENTED")
  
func on_open_controlSettingsMenu_pressed():
	var ei = get_editor_interface()
	ei.select_file(PATH_CONTROLSETTINGSMENU)
	ei.open_scene_from_path(PATH_CONTROLSETTINGSMENU)
	ei.set_main_screen_editor("2D")
  
func on_delete_controlSettings_pressed(accept=false):
	if accept:
		show_confirm_dialog(
			"Delete saved controls?",
			"This will reset the controls set by the user and take the project settings InputMap instead",
			"on_delete_controlSettings_pressed",
			[]
		)
		return
	PersistenceMngr.remove_save("settingsControls")
	
func on_show_saveDir_pressed():
  OS.shell_open("file://" + ProjectSettings.globalize_path(PATH_SAVES))
  
func on_delete_saves_pressed(accept=false):
	if accept:
		show_confirm_dialog(
			"Delete all saves?",
			"This will reset all settings by the user as well as the level progress",
			"on_delete_saves_pressed",
			[]
		)
		return
	PersistenceMngr.remove_all_saves()

func on_open_github_pressed():
	OS.shell_open("https://github.com/AnJ95/godot-toolbox-project")
	
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

func get_description():
	var d = ""
	d += "##########################################\n"
	d += "## TOOLBOX PROJECT                      ##\n"
	d += "##########################################\n"

	d += "# Getting started\n"
	d += "## ToolboxProject bottom control \n"
	d += "The easiest way to get started is to use the panel found at the bottom of the editor, labeled \"ToolboxProject\".\n"
	d += ""

	d += "## Add a config file\n"

	d += "Checklist\n"

	d += "##########################################\n"
	return d;
