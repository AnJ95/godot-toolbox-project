tool
extends Node



func _ready():
	var settingsAudio = PersistenceManager.PersistentObj.new("settingsAudio", {
		"Master" : 80,
		"Music" : 100,
		"Effects" : 100
	})
	settingsAudio.connect("changed", self, "_on_settingsAudio_update")
	PersistenceManager.add_obj(settingsAudio)
	
	
	var settingsControls = PersistenceManager.PersistentObj.new("settingsControls", {
		"Left" : 65,
		"Right" : 66,
		"Up" : 67,
		"Down" : 68
	})
	settingsControls.connect("changed", self, "_on_settingsControls_update")
	PersistenceManager.add_obj(settingsControls)


func _on_settingsAudio_update(settingsAudio):
	for bus in settingsAudio.keys():
		var idx = AudioServer.get_bus_index(bus)
		if idx != -1:
			var vol = settingsAudio[bus]
			# 0 => -80, 100 => 0
			var db = -80 * (1 - (vol / 100.0))
			AudioServer.set_bus_volume_db(idx, db)
			
func _on_settingsControls_update(settingsControls):
	print(settingsControls)
