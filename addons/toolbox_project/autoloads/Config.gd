tool
extends Node


func _ready():
	load_from_config("res://addons/toolbox_project/default_settings.cfg")
	load_from_config()

func load_from_config(path = "res://toolbox_project.cfg"):
	var config = ConfigFile.new()
	var err = config.load(path)
	if err == OK:
		D.l("Config", ["Loading config file at", path])
		
		for section in config.get_sections():
			var keys = config.get_section_keys(section)

			for key in keys:
				# Load custom config value
				var value = config.get_value(section, key)
				
				# if this is a path: load file
				if value is String and value.begins_with("res://"):
					value = try_load(value)
					
				#D.l("Config", ["Setting ", section, ":", key, "=", value])
				
				# if there is a member called like the section,
				# build the Dictionary instead of setting the member
				if get(section) is Dictionary:
					if key.is_valid_integer(): key = int(key)
					get(section)[key] = value
				else:
					set(key, value)
	else:
		D.e("Config", ["Could not load config file at", path, err])
		
func try_load(path):
	if File.new().file_exists(path) or File.new().file_exists(str(path, '.import')):
		return load(path)
	else:
		D.e("Config", ["Could not load ", path])
		return null


####################################################################
# DEBUG

# Global switch for debug mode
var IS_DEBUG

# Deletes all save files on start
var REMOVE_ALL_SAVES

# Global switch for mobile features
var IS_MOBILE


####################################################################
# MENU

# show ScreenMainMenu after ScreenSplash or directly start ScreenGame
var SHOW_MAIN_MENU

# show ScreenLevelMenu on game start or directly start ScreenGame
var SHOW_LEVEL_MENU

# show the settings button in ScreenMainMenu
var SHOW_SETTINGS

# show video settings in ScreenOptionsMenu
var SHOW_SETTINGS_VIDEO

# show audio settings in ScreenOptionsMenu
var SHOW_SETTINGS_AUDIO

# show control settings in ScreenOptionsMenu
var SHOW_SETTINGS_KEYBINDINGS

var TITLE_SONG
var DEFAULT_LEVEL_SONG

var DIALOG_PAUSE_SONG
var DIALOG_WON_SONG
var DIALOG_LOST_SONG

var UI_SELECT
var UI_BACK

####################################################################
# GAME
var DIRECT_RESPAWN_ON_LEVEL_LOST
var DIRECT_NEXT_ON_LEVEL_WON
var UNLOCK_ALL_LEVELS

var USE_MOBILE_CONTROLS

var LEVELS = {}

####################################################################
# OPTIONS

var DEFAULT_OPTIONS_AUDIO = {}

var DEFAULT_OPTIONS_VIDEO = {}
	
####################################################################
# LOGGING

# Global switch for debug logs
var SHOW_LOG = true

# All LogCategories are shown by default. Add true to this Dictionary to
# prevent showing  Logs of this LogCategory
var HIDE_LOG_CATEGORY = {}

# All LogLevels are shown by default. Add true to this Dictionary to
# prevent showing Logs of this LogLevel
var HIDE_LOG_LEVEL = {}


####################################################################
# SCREENS
var SCREEN_SPLASH
var SCREEN_MAIN_MENU
var SCREEN_ABOUT

var SCREEN_OPTIONS_MENU
var SCREEN_OPTIONS_VIDEO_MENU
var SCREEN_OPTIONS_AUDIO_MENU
var SCREEN_OPTIONS_CONTROLS_MENU

var SCREEN_GAME
var SCREEN_LEVEL_MENU
