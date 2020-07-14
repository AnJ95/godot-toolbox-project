extends Node


##################################
# CONFIGURATION

# Global switch for debug mode
var is_debug = true

# Global switch for debug logs
var show_log = true

# All LogCategories are shown by default. Add true to this Dictionary to
# prevent showing  Logs of this LogCategory
var hide_debug_log_categories = {
	LogCategory.PLAYER : false,
}

# All LogLevels are shown by default. Add true to this Dictionary to
# prevent showing Logs of this LogLevel
var hide_log_level = {
	LogCategory.PLAYER : false,
}

####################################################################
# CONSTANTS
enum LogCategory {
	SCENE_MANAGER, MAP, GAME, STATE, SIGNAL, PLAYER
}
enum LogLevel {
	INFO, WARN, ERROR
}

####################################################################
# INTERFACE
# Main debug log function 
#	log_categ		must be of enum LogCategory or a String.
#					Categorizes the logs
#	objs_to_print		object to log or Array of object to log
#	log_level		importance LogLevel for this log
func l(log_categ, objs_to_print, log_level=LogLevel.INFO):
	
	# Don't log if globally off
	if !show_log: return
	
	# Don't log if this LogCategory selectively hidden
	if hide_debug_log_categories.has(log_categ) and hide_debug_log_categories[log_categ] == false: return
	
	# Don't log if this LogLevel selectively hidden
	if hide_log_level.has(log_level) and hide_log_level[log_categ] == false: return
	
	# Convert category index or string
	var categ_str = ""
	if log_categ is String:
		categ_str = log_categ.to_upper()
	if log_categ is int and LogCategory.values().has(log_categ):
		categ_str = str(LogCategory.keys()[log_categ])
	
	# Add spaces to categ_str
	while categ_str.length() < 14:
		categ_str += " "
	
	# Format objs_to_print depending on type
	var objs_str = ""
	if objs_to_print is Array:
		for obj in objs_to_print:
			objs_str += " " + str(obj)
	else: 
		objs_str = " " + str(objs_to_print)
	
	var result_str = "## " + categ_str + " ##  " + objs_str
	if log_level == LogLevel.ERROR:
		printerr(result_str)
	elif log_level == LogLevel.WARN:
		print(result_str)
	else:
		print(result_str)
