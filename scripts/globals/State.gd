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
		"Right" : 68,
		"Up" : 87,
		"Down" : 83,
		"Jump" : 32,
		"Interact" : 16777221
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
	for input_action in settingsControls.keys():
		var scancode = settingsControls[input_action]
		
		# Add this keybind in case it doesn't exist
		if !InputMap.has_action(input_action):
			InputMap.add_action(input_action)
			
		# Erase any already bound events from this input_action
		InputMap.action_erase_events(input_action)
		
		# Add new event to input_action if assigned scancode
		if scancode != null:
			var key_event = InputEventKey.new()
			key_event.set_scancode(scancode)
			InputMap.action_add_event(input_action, key_event)
