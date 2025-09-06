# Main.gd
# Attached to the Main scene's root node.
# Handles the spawning of Echoes and connecting signals.

extends Node2D

# Preload the Echo scene so we can instance it.
var echo_scene = preload("res://Echo.tscn")

# Keep a reference to the player node
@onready var player = $Player

func _ready():
	# Connect the player's spawn signal to our spawning function.
	# We use .connect() instead of the editor to ensure it's always set up.
	player.spawn_echo.connect(on_player_spawn_echo)


func on_player_spawn_echo(playback_data: Array):
	print("Main scene received spawn_echo signal.")
	
	var echo_instance = echo_scene.instantiate()
	
	# Add the new echo to the scene.
	add_child(echo_instance)
	
	# Connect the echo's destruction to the player's recharge function.
	# The 'tree_exited' signal is emitted automatically when a node is removed
	# from the scene tree (e.g., by queue_free()).
	echo_instance.tree_exited.connect(player._on_echo_destroyed)
	
	# Start the echo's playback.
	echo_instance.start_playback(playback_data)
