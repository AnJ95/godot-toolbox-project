extends Node


####################################################################
# DEBUG

# Global switch for debug mode
var is_debug = true


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
	SPLASH, MAIN_MENU, OPTIONS_MENU, GAME
}

const SCREEN_SCENES = {
	Screen.SPLASH:			"res://scenes/screens/ScreenSplash.tscn",
	Screen.MAIN_MENU:			"res://scenes/screens/ScreenMainMenu.tscn",
	Screen.OPTIONS_MENU:		"res://scenes/screens/ScreenOptionsMenu.tscn",
	Screen.GAME:				"res://scenes/screens/ScreenGame.tscn"
}

const INITIAL_SCREEN = Screen.SPLASH
