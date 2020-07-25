extends Node

var title_song_player:AudioStreamPlayer

func _ready():
	title_song_player = AudioStreamPlayer.new()
	add_child(title_song_player)
	title_song_player.bus = "Music"
	title_song_player.stream = C.TITLE_SONG
	
	SignalMngr.connect("screen_entered", self, "_on_screen_entered")

func _on_screen_entered(screen):
	if screen.play_title_song:
		if !title_song_player.playing:
			title_song_player.play()
	else:
		title_song_player.stop()
