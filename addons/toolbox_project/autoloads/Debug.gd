tool
extends Node

####################################################################
# CONSTANTS
enum LogCategory {
	SCREEN_MANAGER, MENU, PERSISTENCE, MAP, GAME, STATE, SIGNAL, PLAYER
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
	if !C.SHOW_LOG: return
	
	# Don't log if this LogCategory selectively hidden
	if C.HIDE_LOG_CATEGORY.has(log_categ) and C.HIDE_LOG_CATEGORY[log_categ] == false: return
	
	# Don't log if this LogLevel selectively hidden
	if C.HIDE_LOG_LEVEL.has(log_level) and C.HIDE_LOG_LEVEL[log_categ] == false: return
	
	# Convert category index or string
	var categ_str = ""
	if log_categ is String:
		categ_str = log_categ.to_upper()
	if log_categ is int and LogCategory.values().has(log_categ):
		categ_str = str(LogCategory.keys()[log_categ])
	
	# Add spaces to categ_str
	while categ_str.length() < 18:
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
		
func w(log_categ, objs_to_print):
	l(log_categ, objs_to_print, LogLevel.WARN)

func e(log_categ, objs_to_print):
	l(log_categ, objs_to_print, LogLevel.ERROR)
