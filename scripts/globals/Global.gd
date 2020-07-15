tool
extends Node

#############################################################
# AUDIO
var volume = {
	"Master" : 100,
	"Music" : 100,
	"Effects" : 100
} setget _volume

func _volume(v):
	volume = v
	for bus in volume.keys():
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), volume_percent_2_db(volume[bus]))

static func volume_percent_2_db(volume):
	# 0 => -80, 100 => 0
	return -80 * (1 - (volume / 100.0))
