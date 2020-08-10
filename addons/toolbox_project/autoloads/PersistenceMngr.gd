tool
extends Node

# PersistenceManager stores state objects that should
# be saved and loaded to the disc.
# Each PersistentObject has a unique name and an associated Dictionary for its data.
#
# To create persistent state Dictionary, use:
#   PersistenceMngr.add_state("settingsAudio", C.DEFAULT_OPTIONS_AUDIO)
#   .connect("changed", self, "_on_settingsAudio_update")
#
# To access the entire Dictionary, use
#	get_state(uid:String)
#	set_state(uid:String, val)
# e.g.: get_state("settingsAudio").Master
#
# Use dot-separated uid to navigate subparts of the Dictionary:
# e.g.: get_state("settingsAudio.Master")

const LOAD_ON_START = 1
const SAVE_ON_SET = 2

var _objs = {}

func _ready():
	if C.REMOVE_ALL_SAVES:
		remove_all_saves()

func remove_all_saves():
	for obj in _objs.values():
			obj._remove_save()
			
func remove_save(uid):
	if _objs.has(uid):
		_objs[uid]._remove_save()

#############################################################
# ADDING NEW STATES

# Adds/Overrides a state object given its uid
func add_state(uid, default, flags=SAVE_ON_SET):
	var persistentObj = PersistentObj.new(uid, default, flags)
	_objs[uid] = persistentObj
	return persistentObj

#############################################################
# GETTER
# Gets a saved state of a PersistenceObject from a given uid,
# for example:	get_state("settingsAudio")
# but also:		get_state("settingsAudio.Master")
func get_state(uid:String):

	var nodes = uid.split(".")

	# Cancel if uid_path has length 0
	if nodes.size() == 0:
		D.e(D.LogCategory.PERSISTENCE, ["get_state", "Could not parse uid [", "UID:", uid, "]" ])
		return null

	# Cancel if uid_paths first node doesnt exists
	if !nodes[0] in _objs:
		D.e(D.LogCategory.PERSISTENCE, ["get_state", "Could not parse uid, invalid Node in Path [", "UID:", uid, ",", "Node:", nodes[0], "]" ])
		return null

	# Iterate through json
	var tree = _objs[nodes[0]].get_state()
	for i in range(1, nodes.size()):
		tree = __try_descend(uid, tree, nodes[i])
		if tree == null:
			return null
	return tree

func __try_descend(uid, tree, node):
	if tree is Array:
		if !node.is_valid_integer():
			D.e(D.LogCategory.PERSISTENCE, ["Could not parse uid, non-integer node on array [", "UID:", uid, ",", "Node:", node, "]" ])
			return null
			
		var inode = int(node)
		if tree.size() > inode:
			return tree[inode]
		else:
			D.e(D.LogCategory.PERSISTENCE, ["Could not parse uid, out of bounds array access [", "UID:", uid, ",", "Node:", node, "]" ])
			return null
	elif tree is Dictionary:
		if tree.has(node):
			return tree[node]
		else:
			D.e(D.LogCategory.PERSISTENCE, ["Could not parse uid, invalid Node in Path [", "UID:", uid, ",", "Node:", node, "]" ])
			return null

#############################################################
# SETTER
# Overwrites the value of a pre-existing PersistenceObject of given uid
# for example:	set_state("settingsAudio", {"Master":80})
# but also:		set_state("settingsAudio.Master", 80)
func set_state(uid:String, val):
	var nodes = uid.split(".")
	if nodes.size() == 0:
		D.e(D.LogCategory.PERSISTENCE, ["set_state", "Could not parse uid [", "UID:", uid, "]" ])
	elif nodes.size() == 1:
		_objs[uid].set_state(val)
	else:
		# First node is entire json
		if !nodes[0] in _objs:
			D.e(D.LogCategory.PERSISTENCE, ["set_state", "Could not parse uid, invalid Node in Path [", "UID:", uid, ",", "Node:", nodes[0], "]" ])
			return false
		var cur_obj = _objs[nodes[0]]
		var tree = cur_obj.get_state()

		# Then iterate from [1, size()-2] to find last branch
		for i in range(1, max(1, nodes.size()-1)):
			tree = __try_descend(uid, tree, nodes[i])
			if tree == null: return false

		# Perform set operation
		var last_node = nodes[nodes.size()-1]
		if tree is Dictionary and tree.has(last_node):
			tree[last_node] = val
		elif tree is Array and last_node.is_valid_integer() and tree.size() > int(last_node):
			tree[int(last_node)] = val
		else:
			D.e(D.LogCategory.PERSISTENCE, ["set_state", "Could not parse uid, invalid Node in Path [", "UID:", uid, ",", "Node:", last_node, "]" ])
			return false

		# If no error: trigger_update
		cur_obj.trigger_update()
		return true


#############################################################
# SUB-CLASS

class PersistentObj:

	signal changed(new_val)
	var uid
	var default
	var val = null

	var flags

	func _init(uid, default, flags=SAVE_ON_SET):
		self.uid = uid
		self.default = default
		self.flags = flags

		# Initially load if flag set:
		if flags & LOAD_ON_START:
			get_state()

	#############################################################
	# SAVING

	func _get_save_path()->String:
		return "user://save_" + uid + ".save"

	func _does_save_exist()->bool:
		var dir:Directory = Directory.new()
		return dir.file_exists(_get_save_path())

	func _remove_save():
		if _does_save_exist():
			var dir:Directory = Directory.new()
			dir.remove(_get_save_path())
			val = default

	func _to_string()->String:
		return JSON.print(val)

	func _save()->bool:
		var file:File = File.new()
		if file.open(_get_save_path(), File.WRITE) == OK:
			var string = _to_string()
			file.store_string(string)
			D.l(D.LogCategory.PERSISTENCE, ["Wrote save [", "UID:", uid, ",", "Data:", string, "]" ])
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
					D.l(D.LogCategory.PERSISTENCE, ["Loaded save [", "UID:", uid, ",", "Data:", val, "]" ])
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
	func get_state():

		# Prevent actual loading in EditorMode, and just use default
		if Engine.is_editor_hint():
			val = default

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
	func set_state(val):
		self.val = val
		trigger_update()

	# Gives a change to save if flag SAVE_ON_SET is set
	func trigger_update():
		emit_signal("changed", get_state())
		# Save if flag set
		if flags & SAVE_ON_SET:
			_save()
