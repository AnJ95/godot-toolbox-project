tool
extends Node


####################################################################
# DEBUG

# Global switch for debug mode
const IS_DEBUG = false

# Deletes all save files on start
const REMOVE_ALL_SAVES = false

# Global switch for mobile features
const IS_MOBILE = false


####################################################################
# PATHS
const BASE_PATH = "res://addons/toolbox_project/"

####################################################################
# MENU

# show ScreenMainMenu after ScreenSplash or directly start ScreenGame
const SHOW_MAIN_MENU = true

# show ScreenLevelMenu on game start or directly start ScreenGame
const SHOW_LEVEL_MENU = false

# show the settings button in ScreenMainMenu
const SHOW_SETTINGS = true

# show video settings in ScreenOptionsMenu
const SHOW_SETTINGS_VIDEO = !IS_MOBILE

# show audio settings in ScreenOptionsMenu
const SHOW_SETTINGS_AUDIO = true

# show control settings in ScreenOptionsMenu
const SHOW_SETTINGS_KEYBINDINGS = !IS_MOBILE

const TITLE_SONG = preload("res://assets/sound/music/28 Towering Blues.ogg")
const DEFAULT_LEVEL_SONG = preload("res://assets/sound/music/03 Before the Dawn.ogg")
const DIALOG_SONG = preload("res://assets/sound/music/27 Coffee Break.ogg")
const UI_SELECT = preload("res://assets/sound/sfx/16687__littlerobotsoundfactory__fantasy-sound-effects-library/270401__littlerobotsoundfactory__menu-select-00.wav")
const UI_BACK = preload("res://assets/sound/sfx/16687__littlerobotsoundfactory__fantasy-sound-effects-library/270393__littlerobotsoundfactory__inventory-open-00.wav")

####################################################################
# GAME
const DIRECT_RESPAWN_ON_LEVEL_LOST = false
const DIRECT_NEXT_ON_LEVEL_WON = false
const UNLOCK_ALL_LEVELS = IS_DEBUG

const USE_MOBILE_CONTROLS = IS_MOBILE

const LEVELS = {
	0:		preload("res://game/levels/PlatformerParallax.tscn"),
	1:		preload("res://game/levels/TopDownIsometric.tscn"),
	2:		preload("res://game/levels/PlatformerAutotile.tscn"),
	3:		preload("res://game/levels/PlatformerDarkCave.tscn"),
	4:		preload("res://game/levels/TopDownDungeonMystery.tscn"),
}

####################################################################
# OPTIONS

const DEFAULT_OPTIONS_AUDIO = {
	"Master" : 80,
	"Music" : 100,
	"Effects" : 100
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

onready var SCREEN_SPLASH = load(BASE_PATH + "scenes/screens/ScreenSplash.tscn")
onready var SCREEN_MAIN_MENU = load(BASE_PATH + "scenes/screens/ScreenMainMenu.tscn")
onready var SCREEN_ABOUT = load(BASE_PATH + "scenes/screens/ScreenAbout.tscn")

onready var SCREEN_OPTIONS_MENU = load(BASE_PATH + "scenes/screens/ScreenOptionsMenu.tscn")
onready var SCREEN_OPTIONS_VIDEO_MENU = load(BASE_PATH + "scenes/screens/ScreenOptionsVideoMenu.tscn")
onready var SCREEN_OPTIONS_AUDIO_MENU = load(BASE_PATH + "scenes/screens/ScreenOptionsAudioMenu.tscn")
onready var SCREEN_OPTIONS_CONTROLS_MENU = load(BASE_PATH + "scenes/screens/ScreenOptionsControlsMenu.tscn")

onready var SCREEN_GAME = load("res://ScreenGame.tscn")
onready var SCREEN_LEVEL_MENU = load(BASE_PATH + "scenes/screens/ScreenLevelMenu.tscn")

