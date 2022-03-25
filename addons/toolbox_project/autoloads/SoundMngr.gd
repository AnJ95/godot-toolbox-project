tool
extends Node

var title_song_player:AudioStreamPlayer

var ui_sound_player:AudioStreamPlayer

func _ready():
	title_song_player = AudioStreamPlayer.new()
	add_child(title_song_player)
	title_song_player.bus = "Music"
	title_song_player.stream = C.TITLE_SONG
	
	ui_sound_player = AudioStreamPlayer.new()
	add_child(ui_sound_player)
	ui_sound_player.bus = "Effects"
	
	SignalMngr.connect("screen_entered", self, "_on_screen_entered")

func _on_screen_entered(screen):
	if screen.play_title_song:
		if !title_song_player.playing:
			title_song_player.play()
	else:
		title_song_player.stop()

func play_ui_sound(stream=C.UI_SELECT):
	if stream:
		ui_sound_player.stream = stream
		ui_sound_player.play()

func _on_settingsAudio_update(settingsAudio):
	for bus in settingsAudio.keys():
		var idx = AudioServer.get_bus_index(bus)
		if idx != -1:
			var vol = settingsAudio[bus]
			var db = linear2db(vol / 100.0)
			AudioServer.set_bus_volume_db(idx, db)
