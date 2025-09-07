class_name Main
extends Node2D

@export var player: Player
@export var pressure_plate: PressurePlate
@export var door: Door
@export var pedestal: Pedestal
@export var hud: HUD
@export var transition_area: TransitionArea

@export var artifact: Artifact

var echo_scene = preload("res://Echo.tscn")


func _ready():
	var required_nodes = [player, pressure_plate, door, pedestal, hud, transition_area]
	for node in required_nodes:
		if not node:
			print("ERROR: One or more exported nodes are not assigned in the Main scene.")
			return

	player.spawn_echo.connect(on_player_spawn_echo)
	player.charges_changed.connect(hud.update_charge_display)
	
	pressure_plate.activated.connect(door.open_door)
	pressure_plate.deactivated.connect(door.close_door)
	transition_area.player_entered_transition.connect(_on_player_reached_end)
	pedestal.artifact_delivered.connect(_on_artifact_delivered)
	
	hud.update_charge_display(player.echo_charges)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://MainMenu.tscn")


func on_player_spawn_echo(playback_data: Array[Dictionary], spawn_pos: Vector2):
	var echo_instance = echo_scene.instantiate()
	echo_instance.global_position = spawn_pos
	echo_instance.set_playback_data(playback_data)
	echo_instance.playback_finished.connect(player.restore_charge)
	add_child(echo_instance)


func _on_artifact_delivered():
	# ADDED THIS PRINT STATEMENT FOR DEBUGGING
	print("Main scene received artifact_delivered signal. VICTORY!")
	get_tree().reload_current_scene()
func _on_player_reached_end(scene_path: String):
	get_tree().change_scene_to_file(scene_path)
