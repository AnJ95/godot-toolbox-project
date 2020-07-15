tool
extends Node



func _ready():
	PersistenceManager.add_obj(PersistenceManager.PersistentObj.new("settingsAudio", {
		"Master" : 80,
		"Music" : 100,
		"Effects" : 100
	}))
