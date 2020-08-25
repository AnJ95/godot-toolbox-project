tool
extends Control

# Screens
onready var does_screen_exist:Control = $HBoxContainer/VBoxContainer/DoesScreenExist
onready var icon_does_screen_exist:TextureRect = $HBoxContainer/VBoxContainer/DoesScreenExist/Icon

onready var btn_create_screens:Button = $HBoxContainer/VBoxContainer/CreateScreens
onready var btn_make_screenSplashDefault:Button = $HBoxContainer/VBoxContainer/MakeScreenSplashDefault
onready var btn_reset_screens:Button = $HBoxContainer/VBoxContainer/ResetScreens

onready var root_screens:Control = $HBoxContainer/VBoxContainer/ScrollContainer/Screens

# Config File
onready var icon_does_config_exist:TextureRect = $HBoxContainer/VBoxContainer2/DoesConfigExist/Icon
onready var label_does_config_exist:Label = $HBoxContainer/VBoxContainer2/DoesConfigExist/Label

onready var btn_create_config:Button = $HBoxContainer/VBoxContainer2/CreateConfig
onready var btn_open_config:Button = $HBoxContainer/VBoxContainer2/OpenConfig
onready var btn_reset_config:Button = $HBoxContainer/VBoxContainer2/ResetConfig

# Bus Layout
onready var icon_is_busLayout_set:TextureRect = $HBoxContainer/VBoxContainer4/IsBusLayoutSet/Icon
onready var label_is_busLayout_set:Label = $HBoxContainer/VBoxContainer4/IsBusLayoutSet/Label

onready var btn_set_busLayout:Button = $HBoxContainer/VBoxContainer4/SetBusLayout
onready var btn_show_busLayout:Button = $HBoxContainer/VBoxContainer4/ShowBusLayout

# Theme
onready var btn_open_theme:Button = $HBoxContainer/VBoxContainer3/ShowTheme
onready var btn_show_themeAtlas:Button = $HBoxContainer/VBoxContainer3/ShowThemeAtlas

# Controls
onready var btn_open_projectInputMap:Button = $HBoxContainer/VBoxContainer5/OpenProjectInputMap
onready var btn_open_controlSettingsMenu:Button = $HBoxContainer/VBoxContainer5/OpenControlSettingsMenu
onready var btn_delete_controlSetting:Button = $HBoxContainer/VBoxContainer5/DeleteControlSettings

# Persistence Manager
onready var btn_show_saveDir:Button = $HBoxContainer/VBoxContainer6/ShowSaveDir
onready var btn_delete_saves:Button = $HBoxContainer/VBoxContainer6/DeleteSaves

# CONSTS
const ScreenInfo = preload("res://addons/toolbox_project/dock/ScreenInfo.tscn")
const Icon = preload("res://addons/toolbox_project/assets/logo/logo32.png")

const PATH_SCREENS = "res://screens/"
const PATH_SCREENS_DEFAULT = "res://addons/toolbox_project/defaults/screens/"
const PATH_CONFIG = "res://toolbox_project.cfg"
const PATH_CONFIG_DEFAULT = "res://addons/toolbox_project/defaults/toolbox_project.cfg"

const PATH_THEME = "res://addons/toolbox_project/assets/theme.tres"
const PATH_THEME_ATLAS = "res://addons/toolbox_project/assets/theme.png"
const PATH_THEME_TESTER = "res://addons/toolbox_project/scenes/ui/ThemeTester.tscn"

const PATH_BUSLAYOUT = "res://addons/toolbox_project/bus_layout.tres"

const PATH_CONTROLSETTINGSMENU = "res://addons/toolbox_project/scenes/ui/menu/controls/ControlMenu.tscn"
const PATH_SAVES = "user://"
const PATH_CONTROLSETTINGS = "user://save_settingsControls.save"

var plugin:EditorPlugin
var ei:EditorInterface
var gui:Control


func _ready():
	recreate_screen_infos()
	update_ui()


func get_default_screens():
	var screenDir:Directory = Directory.new()
	var screens = []
	
	if screenDir.open(PATH_SCREENS_DEFAULT) == OK:
		screenDir.list_dir_begin()
		var file_name = screenDir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				screens.append(file_name)
			file_name = screenDir.get_next()
			
	return screens

func recreate_screen_infos():
	for child in root_screens.get_children():
		child.queue_free()
	for screen in get_default_screens():
		var inst = ScreenInfo.instance()
		inst.init_gui(self, screen.replace(".tscn", ""), PATH_SCREENS_DEFAULT + screen, PATH_SCREENS + screen)
		root_screens.add_child(inst)

func update_ui():
	var f = File.new()
	
	var does_config_exist = f.file_exists(PATH_CONFIG)
	var does_any_screen_exist = false
	var is_main_scene_set = ProjectSettings.get_setting("application/run/main_scene") == PATH_SCREENS + "ScreenSplash.tscn"
	for screenFileName in get_default_screens():
		does_any_screen_exist = does_any_screen_exist or File.new().file_exists(PATH_SCREENS + screenFileName)
	var is_busLayout_set = ProjectSettings.get("audio/default_bus_layout") == PATH_BUSLAYOUT
	
	does_screen_exist.visible = !does_any_screen_exist
	$HBoxContainer/VBoxContainer/LabelDescription.visible = !does_any_screen_exist
	$HBoxContainer/VBoxContainer/ScrollContainer.visible = does_any_screen_exist
	
	btn_create_screens.disabled = does_any_screen_exist
	btn_make_screenSplashDefault.disabled = is_main_scene_set
	btn_reset_screens.disabled = !does_any_screen_exist
	
	btn_create_config.disabled = does_config_exist
	btn_open_config.disabled = !does_config_exist
	btn_reset_config.disabled = !does_config_exist
	btn_reset_config.disabled = !does_config_exist
	
	btn_set_busLayout.disabled = is_busLayout_set
	
	icon_does_screen_exist.texture = gui.get_icon("StatusError", "EditorIcons")
	
	icon_does_config_exist.texture = gui.get_icon("StatusSuccess" if does_config_exist else "StatusError", "EditorIcons")
	label_does_config_exist.text = PATH_CONFIG# + (" exists" if does_config_exist else " does not exist!")
	
	icon_is_busLayout_set.texture = gui.get_icon("StatusSuccess" if is_busLayout_set else "StatusError", "EditorIcons")
	label_is_busLayout_set.text = "BusLayout" + (" is set" if is_busLayout_set else " is not set!")
	
	for child in root_screens.get_children():
		child.update_ui()
	
func show_confirm_dialog(title, text, then_emit, then_binds):
	var dialog = ConfirmationDialog.new()
	dialog.window_title = title
	dialog.dialog_text = text
	ei.get_base_control().add_child(dialog)
	dialog.popup_centered_minsize()
	if dialog.is_connected("confirmed", self, then_emit):
		dialog.disconnect("confirmed", self, then_emit)
	dialog.connect("confirmed", self, then_emit, then_binds, CONNECT_ONESHOT)

var cur_scene
func _on_scene_changed(scene):
	cur_scene = scene

func open_or_reload_scene(scene):
	if cur_scene == scene:
		ei.open_scene_from_path(scene)
	else:
		ei.open_scene_from_path(scene)
		yield(plugin, "scene_changed")
		
func set_main_screen_and_await(main_screen):
	ei.set_main_screen_editor(main_screen)
	yield(plugin, "main_screen_changed")

	
func copy_default_file(path_from, path_to, btn, accept=false, open_after=true):
	if accept:
		show_confirm_dialog(
			"Reset " + path_to + "?",
			"Are you sure to reset? This will delete the current " + path_to + ".",
			"copy_default_file",
			[path_from, path_to, btn, false, open_after]
		)
		return
		
	var dir = Directory.new()
	if OK != dir.copy(path_from, path_to):
		var prev_text = btn.text
		btn.text = "Error"
		yield(get_tree().create_timer(1), "timeout")
		btn.text = prev_text
		return
		
	if open_after:
		if path_to.ends_with(".tscn"):
			open_or_reload_scene(path_to)
			ei.select_file(path_to)
			set_main_screen_and_await("2D")
		else:
			OS.shell_open("file://" + ProjectSettings.globalize_path(path_to))
		
	update_ui()	


func _on_OpenGithub_pressed():
	OS.shell_open("https://github.com/AnJ95/godot-toolbox-project")
	
func _on_CreateScreens_pressed():
	if !Directory.new().dir_exists(PATH_SCREENS):
		Directory.new().make_dir(PATH_SCREENS)
	
	for screenFileName in get_default_screens():
		copy_default_file(
			PATH_SCREENS_DEFAULT + screenFileName,
			PATH_SCREENS + screenFileName,
			btn_create_screens,
			false,
			false
		)
	
	ei.get_resource_filesystem().scan()
	
func _on_MakeScreenSplashDefault_pressed():
	ProjectSettings.set_setting("application/run/main_scene", PATH_SCREENS + "ScreenSplash.tscn")
	update_ui()
	
	
func _on_ResetScreens_pressed():
	show_confirm_dialog(
		"Reset all Screens?",
		"This will reset all Screens in the list above to their default! Take care!",
		"_on_CreateScreens_pressed",
		[]
	)

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
	open_or_reload_scene(PATH_THEME_TESTER)
	set_main_screen_and_await("2D")

	
	yield(get_tree().create_timer(0.1), "timeout")
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
	open_or_reload_scene(PATH_CONTROLSETTINGSMENU)
	set_main_screen_and_await("2D")


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

func _on_OpenGlobal_pressed(global_name):
	var path = plugin.AUTOLOADS_PATH + global_name + ".gd"
	ei.select_file(path)
	ei.get_script_editor().open_script_create_dialog("", path)
