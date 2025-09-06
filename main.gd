# Main.gd
# Attached to the Main scene's root node.
# Handles echo spawning and connecting puzzle elements.

extends Node2D

var echo_scene = preload("res://Echo.tscn")

@export var player: Player
@export var pressure_plate: PressurePlate
@export var door: Door
@export var artifact: Artifact

func _ready():
	# Connect player signals
	player.spawn_echo.connect(on_player_spawn_echo)

	# --- Phase 3: Connect all the puzzle pieces together ---
	if pressure_plate and door:
		pressure_plate.activated.connect(door.open_door)
		pressure_plate.deactivated.connect(door.close_door)
	
	if artifact and player:
		artifact.collected.connect(player._on_artifact_collected)
	# ------------------------------------------------------


func on_player_spawn_echo(playback_data: Array):
	var echo_instance = echo_scene.instantiate()
	add_child(echo_instance)
	echo_instance.tree_exited.connect(player._on_echo_destroyed)
	echo_instance.start_playback(playback_data)


func _on_pressure_plate_activated() -> void:
	pass # Replace with function body.


func _on_pressure_plate_deactivated() -> void:
	pass # Replace with function body.
