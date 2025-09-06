extends Node2D
@onready var echo_scene = preload("res://Echo.tscn")
@onready var player = $Player
func _ready():
	player.spawn_echo.connect(on_player_spawn_echo)
func on_player_spawn_echo(playback_data: Array):
	print("Main scene received spawn_echo signal.")
	var new_echo = echo_scene.instantiate()
	add_child(new_echo)
	new_echo.start_playback(playback_data)
	


func _on_player_spawn_echo(playback_data: Variant) -> void:
	pass # Replace with function body.
