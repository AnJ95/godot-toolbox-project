tool
extends Node


####################################################################
# DEBUG

# Global switch for debug mode
const IS_DEBUG = true

# Deletes all save files on start
const REMOVE_ALL_SAVES = false


####################################################################
# MENU

# show ScreenMainMenu after ScreenSplash or directly start ScreenGame
const SHOW_MAIN_MENU = true

# show ScreenLevelMenu on game start or directly start ScreenGame
const SHOW_LEVEL_MENU = true

# show the settings button in ScreenMainMenu
const SHOW_SETTINGS = true

# show video settings in ScreenOptionsMenu
const SHOW_SETTINGS_VIDEO = true

# show audio settings in ScreenOptionsMenu
const SHOW_SETTINGS_AUDIO = true

# show control settings in ScreenOptionsMenu
const SHOW_SETTINGS_KEYBINDINGS = true

####################################################################
# GAME
const DIRECT_RESPAWN_ON_LEVEL_LOST = false
const DIRECT_NEXT_ON_LEVEL_WON = false
const UNLOCK_ALL_LEVELS = IS_DEBUG

const USE_MOBILE_CONTROLS = true

const LEVELS = {
	0:		preload("res://scenes/game/levels/PlatformerParallax.tscn"),
	1:		preload("res://scenes/game/levels/TopDownIsometric.tscn"),
	2:		preload("res://scenes/game/levels/PlatformerAutotile.tscn"),
	3:		preload("res://scenes/game/levels/PlatformerDarkCave.tscn"),
	4:		preload("res://scenes/game/levels/TopDownDungeonMystery.tscn"),
}

####################################################################
# OPTIONS

const DEFAULT_OPTIONS_AUDIO = {
	"Master" : 80,
	"Music" : 100,
	"Effects" : 100
}
const DEFAULT_OPTIONS_KEYBINDINGS = {
	"Left" : 65,
	"Right" : 68,
	"Up" : 87,
	"Down" : 83,
	"Jump" : 32,
	"SwitchDemo" : 49,
	"SwitchSkin" : 50,
	"Pause" : 80,
	"Interact" : 16777221
}

const DEFAULT_OPTIONS_VIDEO = {
	"Fullscreen" : false,
	"VSync" : true
}
	
####################################################################
# LOGGING

# Global switch for debug logs
const show_log = true

# All LogCategories are shown by default. Add true to this Dictionary to
# prevent showing  Logs of this LogCategory
var hide_debug_log_categories = {
#	D.LogCategory.PLAYER : true,
}

# All LogLevels are shown by default. Add true to this Dictionary to
# prevent showing Logs of this LogLevel
var hide_log_level = {
#	D.LogCategory.PLAYER : true,
}


####################################################################
# SCREENS

enum Screen {
	SPLASH, MAIN_MENU, ABOUT,
	OPTIONS_MENU, OPTIONS_VIDEO_MENU, OPTIONS_AUDIO_MENU, OPTIONS_CONTROLS_MENU,
	LEVEL_MENU, GAME
}

const SCREEN_SCENES = {
	Screen.SPLASH:				"res://scenes/screens/ScreenSplash.tscn",
	Screen.MAIN_MENU:				"res://scenes/screens/ScreenMainMenu.tscn",
	Screen.ABOUT:					"res://scenes/screens/ScreenAbout.tscn",
	
	Screen.OPTIONS_MENU:			"res://scenes/screens/ScreenOptionsMenu.tscn",
	Screen.OPTIONS_VIDEO_MENU:		"res://scenes/screens/ScreenOptionsVideoMenu.tscn",
	Screen.OPTIONS_AUDIO_MENU:		"res://scenes/screens/ScreenOptionsAudioMenu.tscn",
	Screen.OPTIONS_CONTROLS_MENU:	"res://scenes/screens/ScreenOptionsControlsMenu.tscn",
	
	Screen.GAME:					"res://scenes/screens/ScreenGame.tscn",
	Screen.LEVEL_MENU:			"res://scenes/screens/ScreenLevelMenu.tscn"
	
}

const INITIAL_SCREEN = Screen.SPLASH
