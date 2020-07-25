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

const UI_SELECT = preload("res://assets/sound/sfx/16687__littlerobotsoundfactory__fantasy-sound-effects-library/270401__littlerobotsoundfactory__menu-select-00.wav")
const UI_BACK = preload("res://assets/sound/sfx/16687__littlerobotsoundfactory__fantasy-sound-effects-library/270393__littlerobotsoundfactory__inventory-open-00.wav")
func play_ui_sound(stream=UI_SELECT):
	ui_sound_player.stream = stream
	ui_sound_player.play()
