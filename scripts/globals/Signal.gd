tool
extends Node

#####################################################################
# SIGNALS

# Screen lifecycle
signal screen_entered(screen)
signal screen_left(screen)

# Game lifecycle
signal game_started
signal game_paused(pause_on)
signal game_ended

# Player
signal player_died

# Score
signal score_added(delta)
