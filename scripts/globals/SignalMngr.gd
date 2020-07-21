tool
extends Node

#####################################################################
# SIGNALS

# Screen lifecycle
signal screen_entered(screen)
signal screen_left(screen)

# Game lifecycle
signal game_started()
signal game_paused(pause_on)
signal game_ended()

signal level_started(root_node)
signal level_lost()
signal level_won()

signal restart_level()
signal next_level()

# Score
signal score_added(delta)
