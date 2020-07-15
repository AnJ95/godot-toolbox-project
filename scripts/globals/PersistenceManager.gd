tool
extends Node

var _objs = {}


#############################################################
# GETTERS

# Gets a PersistenceObject from a given uid,
# And NOT the saved state itself
# for example:	var master = get_obj("settingsAudio").get_val().Master
func get_obj(uid:String):
	if has_obj(uid):
		return _objs[uid]
	else:
		D.e(D.LogCategory.PERSISTENCE, ["Could not get PersistentObj [", "UID:", uid, "]" ])
		return null

# Gets a saved state of a PersistenceObject from a given uid,
# for example:	var master = get_val("settingsAudio").Master
func get_val(uid:String):
	var obj = get_obj(uid)
	if obj:
		return obj.get_val()

# Gets a saved state of a PersistenceObject from a given uid path,
# for example:	var master = get_val_from_ui_path("settingsAudio.Master")
func get_val_from_ui_path(uid_path:String):
	var nodes = uid_path.split(".")
	if nodes.size() > 0:
		var val = get_val(nodes[0])
		for i in range(1, nodes.size()):
			var node = nodes[i]
			if val.has(node):
				val = val[node]
			else:
				D.e(D.LogCategory.PERSISTENCE, ["Could not parse uid path, invalid Node in Path [", "UID-Path:", uid_path, ",", "Node:", node, "]" ])
				break
		return val
	else:
		D.e(D.LogCategory.PERSISTENCE, ["Could not parse uid path [", "UID-Path:", uid_path, "]" ])
		return null

#############################################################
# SETTERS

# Sets the state of a PersistenceObject given uid to a given val
# for example:	set_val("settingsAudio", {"Master":100})
func set_val(uid:String, val):
	if has_obj(uid):
		return _objs[uid].set_val(val)
		
# Sets the state of a PersistenceObject given uid path to a given val
# for example:	set_val_from_ui_path("settingsAudio.Master", 100)
func set_val_from_ui_path(uid_path:String, val):
	var nodes = uid_path.split(".")
	if nodes.size() == 0:
		D.e(D.LogCategory.PERSISTENCE, ["Could not parse uid path [", "UID-Path:", uid_path, "]" ])
	elif nodes.size() == 1:
		set_val(uid_path, val)
	else:
		# First node is entire json
		var entire_obj = get_obj(nodes[0])
		if entire_obj == null:
			D.e(D.LogCategory.PERSISTENCE, ["Could not parse uid path, invalid Node in Path [", "UID-Path:", uid_path, ",", "Node:", nodes[0], "]" ])
			return false
		var cur_val = entire_obj.get_val()
		
		# Then iterate from [1, size()-2] to find last branch
		for i in range(1, max(1, nodes.size()-1)):
			var node = nodes[i]
			if cur_val.has(node):
				cur_val = cur_val[node]
			else:
				D.e(D.LogCategory.PERSISTENCE, ["Could not parse uid path, invalid Node in Path [", "UID-Path:", uid_path, ",", "Node:", node, "]" ])
				return false
		
		# Perform set operation
		var last_node = nodes[nodes.size()-1]
		if cur_val.has(last_node):
			cur_val[last_node] = val
		else:
			D.e(D.LogCategory.PERSISTENCE, ["Could not parse uid path, invalid Node in Path [", "UID-Path:", uid_path, ",", "Node:", last_node, "]" ])
			return false
		
		# If no error: trigger_update
		entire_obj.trigger_update()
		return true
	
#############################################################
# ADDING

# Adds/Overrides a PersistentObj given persistentObj.uid
func add_obj(persistentObj):
	_objs[persistentObj.uid] = persistentObj
	
# Checks for existence of PersistentObj given a uid
func has_obj(uid:String):
	return uid in _objs


	
#############################################################
# SETTERS	
class PersistentObj:
	
	var uid
	var default
	var val = null
	
	var flags
	const LOAD_ON_START = 1
	const SAVE_ON_SET = 2
	
	func _init(uid, default, flags=SAVE_ON_SET):
		self.uid = uid
		self.default = default
		self.flags = flags
		
		# Initially load if flag set:
		if flags & LOAD_ON_START:
			get_val()
	
	#############################################################
	# SAVING

	func _get_save_path()->String:
		return "user://save_" + uid + ".save"
		
	func _does_save_exist()->bool:
		var dir:Directory = Directory.new()
		return dir.file_exists(_get_save_path())
	
	func _to_string()->String:
		return JSON.print(val)
		
	func _save()->bool:
		var file:File = File.new()
		if file.open(_get_save_path(), File.WRITE) == OK:
			var string = _to_string()
			file.store_string(string)
			return true
		else:
			D.e(D.LogCategory.PERSISTENCE, ["Error opening PersistentObj File for writing [", "UID:", uid, "]" ])
		return false
	
	#############################################################
	# LOADING
		
	func _load_from_string(string:String)->bool:
		var json_result = JSON.parse(string)
		if json_result.error == OK:
			val = json_result.result
			return true
		else:
			D.e(D.LogCategory.PERSISTENCE, ["Error parsing PersistentObj from json [", "UID:", uid, ",", "str:", string, "]" ])
			return false
		
	func _load_from_save()->bool:
		if _does_save_exist():
			var file:File = File.new()
			if file.open(_get_save_path(), File.READ) == OK:
				var string = file.get_as_text()
				if _load_from_string(string):
					D.l(D.LogCategory.PERSISTENCE, ["Loaded save [", "UID:", uid, "]" ])
					return true
			else:
				D.e(D.LogCategory.PERSISTENCE, ["Error opening PersistentObj File [", "UID:", uid, "]" ])
		return false
	
	#############################################################
	# INTERFACE
	
	# Singleton Function that
	#	* Ensures existence of one and only value
	#	* Loads from a File if not existent
	#	* Uses a default value otherwise
	func get_val():
		# 1: Try if local reference exists
		if val != null:
			pass
		
		# 2: Try loading from save file
		elif _does_save_exist():
			_load_from_save()
		
		# 3: Use default value else
		else:
			val = default
		
		return val
	
	# Sets the saved value of this PersistentObj
	# triggers_update to save to file if SAVE_ON_SET is set
	func set_val(val):
		self.val = val
		trigger_update()
	
	# Gives a change to save if flag SAVE_ON_SET is set
	func trigger_update():
		# Save if flag set
		if flags & SAVE_ON_SET:
			_save()
