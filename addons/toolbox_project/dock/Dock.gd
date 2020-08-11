tool
extends HBoxContainer

# Screens
onready var icon_does_screenGame_exist:TextureRect = $VBoxContainer/DoesScreenGameExist/Icon
onready var label_does_screenGame_exist:Label = $VBoxContainer/DoesScreenGameExist/Label

onready var btn_create_screenGame:Button = $VBoxContainer/CreateScreens
onready var btn_reset_screenGame:Button = $VBoxContainer/ResetScreens
onready var btn_open_screenGame:Button = $VBoxContainer/OpenScreenGame
onready var btn_show_all_screens:Button = $VBoxContainer/ShowAllScreens

# Config File
onready var icon_does_config_exist:TextureRect = $VBoxContainer2/DoesConfigExist/Icon
onready var label_does_config_exist:Label = $VBoxContainer2/DoesConfigExist/Label

onready var btn_create_config:Button = $VBoxContainer2/CreateConfig
onready var btn_open_config:Button = $VBoxContainer2/OpenConfig
onready var btn_reset_config:Button = $VBoxContainer2/ResetConfig

# Bus Layout
onready var icon_is_busLayout_set:TextureRect = $VBoxContainer4/IsBusLayoutSet/Icon
onready var label_is_busLayout_set:Label = $VBoxContainer4/IsBusLayoutSet/Label

onready var btn_set_busLayout:Button = $VBoxContainer4/SetBusLayout
onready var btn_show_busLayout:Button = $VBoxContainer4/ShowBusLayout

# Theme
onready var btn_open_theme:Button = $VBoxContainer3/ShowTheme
onready var btn_show_themeAtlas:Button = $VBoxContainer3/ShowThemeAtlas

onready var btn_open_projectInputMap:Button = $VBoxContainer5/OpenProjectInputMap
onready var btn_open_controlSettingsMenu:Button = $VBoxContainer5/OpenControlSettingsMenu
onready var btn_delete_controlSetting:Button = $VBoxContainer5/DeleteControlSettings

onready var btn_show_saveDir:Button = $VBoxContainer6/ShowSaveDir
onready var btn_delete_saves:Button = $VBoxContainer6/DeleteSaves

const Icon = preload("res://addons/toolbox_project/assets/logo/logo32.png")

const PATH_SCREENGAME = "res://ScreenGame.tscn"
const PATH_SCREENGAME_DEFAULT = "res://addons/toolbox_project/defaults/ScreenGame.tscn"
const PATH_CONFIG = "res://toolbox_project.cfg"
const PATH_CONFIG_DEFAULT = "res://addons/toolbox_project/defaults/toolbox_project.cfg"

const PATH_SCREENS = "res://addons/toolbox_project/scenes/screens/Screen.tscn"

const PATH_THEME = "res://addons/toolbox_project/assets/theme.tres"
const PATH_THEME_ATLAS = "res://addons/toolbox_project/assets/theme.png"
const PATH_THEME_TESTER = "res://addons/toolbox_project/scenes/ui/ThemeTester.tscn"

const PATH_BUSLAYOUT = "res://addons/toolbox_project/bus_layout.tres"

const PATH_CONTROLSETTINGSMENU = "res://addons/toolbox_project/scenes/ui/menu/controls/ControlMenu.tscn"
const PATH_SAVES = "user://"
const PATH_CONTROLSETTINGS = "user://save_settingsControls.save"

var ei
var gui

func _ready():	
	update_ui()

func update_ui():
	var f = File.new()
	var does_screenGame_exist = f.file_exists(PATH_SCREENGAME)
	var does_config_exist = f.file_exists(PATH_CONFIG)
	var is_busLayout_set = ProjectSettings.get("audio/default_bus_layout") == PATH_BUSLAYOUT
	
	btn_create_screenGame.disabled = does_screenGame_exist
	btn_open_screenGame.disabled = !does_screenGame_exist
	btn_reset_screenGame.disabled = !does_screenGame_exist
	
	btn_create_config.disabled = does_config_exist
	btn_open_config.disabled = !does_config_exist
	btn_reset_config.disabled = !does_config_exist
	btn_reset_config.disabled = !does_config_exist
	
	btn_set_busLayout.disabled = is_busLayout_set
	
	
	icon_does_screenGame_exist.texture = gui.get_icon("StatusSuccess" if does_screenGame_exist else "StatusError", "EditorIcons")
	label_does_screenGame_exist.text = PATH_SCREENGAME# + (" exists" if does_screenGame_exist else " does not exist!")
	
	icon_does_config_exist.texture = gui.get_icon("StatusSuccess" if does_config_exist else "StatusError", "EditorIcons")
	label_does_config_exist.text = PATH_CONFIG# + (" exists" if does_config_exist else " does not exist!")
	
	icon_is_busLayout_set.texture = gui.get_icon("StatusSuccess" if is_busLayout_set else "StatusError", "EditorIcons")
	label_is_busLayout_set.text = "BusLayout" + (" is set" if is_busLayout_set else " is not set!")
	
func show_confirm_dialog(title, text, then_emit, then_binds):
	var dialog = ConfirmationDialog.new()
	dialog.window_title = title
	dialog.dialog_text = text
	ei.get_base_control().add_child(dialog)
	dialog.popup_centered_minsize()
	if dialog.is_connected("confirmed", self, then_emit):
		dialog.disconnect("confirmed", self, then_emit)
	dialog.connect("confirmed", self, then_emit, then_binds, CONNECT_ONESHOT)
	
func _on_OpenGithub_pressed():
	OS.shell_open("https://github.com/AnJ95/godot-toolbox-project")
	
func copy_default_file(path_from, path_to, btn, accept=false):
	if accept:
		show_confirm_dialog(
			"Reset " + path_to + "?",
			"Are you sure to reset? This will delete the current " + path_to + ".",
			"copy_default_file",
			[path_from, path_to, btn, false]
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
			ei.open_scene_from_path(path_to)
			ei.reload_scene_from_path(path_to)
			ei.select_file(path_to)
			ei.set_main_screen_editor("2D")
		else:
			OS.shell_open("file://" + ProjectSettings.globalize_path(path_to))
		
		update_ui()	

func _on_CreateScreens_pressed():
	copy_default_file(PATH_SCREENGAME_DEFAULT, PATH_SCREENGAME, btn_create_screenGame)

func _on_OpenScreenGame_pressed():
	ei.select_file(PATH_SCREENGAME)
	ei.open_scene_from_path(PATH_SCREENGAME)
	ei.set_main_screen_editor("2D")


func _on_ShowAllScreens_pressed():
	ei.select_file(PATH_SCREENS)


func _on_ResetScreens_pressed():
	copy_default_file(PATH_SCREENGAME_DEFAULT, PATH_SCREENGAME, btn_create_screenGame, true)


func _on_CreateConfig_pressed():
	copy_default_file(PATH_CONFIG_DEFAULT, PATH_CONFIG, btn_create_config)
	
func _on_OpenConfig_pressed():
	ei.select_file(PATH_CONFIG)
	OS.shell_open("file://" + ProjectSettings.globalize_path(PATH_CONFIG))
	
func _on_ResetConfig_pressed():
	copy_default_file(PATH_CONFIG_DEFAULT, PATH_CONFIG, btn_create_config, true)

func _on_SetBusLayout_pressed():
	ProjectSettings.set("audio/default_bus_layout", PATH_BUSLAYOUT)
	update_ui()
	
func _on_ShowBusLayout_pressed():
	ei.select_file(PATH_BUSLAYOUT)
	ei.edit_resource(preload(PATH_BUSLAYOUT))


func _on_ShowThemeAtlas_pressed():
	ei.select_file(PATH_THEME_ATLAS)
	ei.edit_resource(preload(PATH_THEME_ATLAS))


func _on_ShowTheme_pressed():
	var prev_open = PATH_THEME_TESTER in ei.get_open_scenes()
	
	ei.open_scene_from_path(PATH_THEME_TESTER)
	if !prev_open: yield(self, "scene_changed")
	ei.set_main_screen_editor("2D")
	
	ei.select_file(PATH_THEME)
	ei.edit_resource(preload(PATH_THEME))


func _on_OpenProjectInputMap_pressed():
	print("NOT IMPLEMENTED")


func _on_DeleteControlSettings_pressed(accept=true):
	if accept:
		show_confirm_dialog(
			"Delete saved controls?",
			"This will reset the controls set by the user and take the project settings InputMap instead",
			"_on_DeleteControlSettings_pressed",
			[false]
		)
		return
	PersistenceMngr.remove_save("settingsControls")

func _on_OpenControlSettingsMenu_pressed():
	ei.select_file(PATH_CONTROLSETTINGSMENU)
	ei.open_scene_from_path(PATH_CONTROLSETTINGSMENU)
	ei.set_main_screen_editor("2D")


func _on_ShowSaveDir_pressed():
	OS.shell_open("file://" + ProjectSettings.globalize_path(PATH_SAVES))


func _on_DeleteSaves_pressed(accept=true):
	if accept:
		show_confirm_dialog(
			"Delete all saves?",
			"This will reset all settings by the user as well as the level progress",
			"_on_DeleteSaves_pressed",
			[false]
		)
		return
	PersistenceMngr.remove_all_saves()
