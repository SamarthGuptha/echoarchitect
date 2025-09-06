class_name Main
extends Node2D

@export var player: Player
@export var pressure_plate: PressurePlate
@export var door: Door
@export var artifact: Artifact
@export var pedestal: Pedestal
@export var hud: HUD

var echo_scene = preload("res://Echo.tscn")

func _ready():
	var required_nodes = [player, pressure_plate, door, artifact, pedestal, hud]
	for node in required_nodes:
		if not node:
			print("ERROR: One or more exported nodes are not assigned in the Main scene.")
			return

	player.spawn_echo.connect(on_player_spawn_echo)
	player.charges_changed.connect(hud.update_charge_display)
	
	pressure_plate.activated.connect(door.open_door)
	pressure_plate.deactivated.connect(door.close_door)
	
	artifact.collected.connect(player.collect_artifact)
	
	pedestal.artifact_delivered.connect(_on_artifact_delivered)
	
	hud.update_charge_display(player.echo_charges)

func on_player_spawn_echo(playback_data, spawn_pos):
	var echo_instance = echo_scene.instantiate()
	echo_instance.global_position = spawn_pos
	echo_instance.set_playback_data(playback_data)
	echo_instance.playback_finished.connect(player.restore_charge)
	add_child(echo_instance)

func _on_artifact_delivered():
	print("Main scene received artifact_delivered signal. VICTORY!")
