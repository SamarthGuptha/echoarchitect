class_name Player
extends CharacterBody2D

signal spawn_echo(playback_data, spawn_position)
signal charges_changed(new_charge_count)

@export var speed = 130.0
@export var jump_velocity = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_recording = false
var has_artifact = false
var carried_artifact = null 

var recording_data: Array[Dictionary] = []
var echo_charges = 3
const MAX_CHARGES = 3

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed if direction else move_toward(velocity.x, 0, speed)
	move_and_slide()
	
	handle_recording()
	handle_playback()
	update_animations()

func handle_recording():
	if Input.is_action_just_pressed("record"):
		is_recording = not is_recording
		if is_recording:
			recording_data.clear()
			print("Rec started...")
		else:
			print("Recording stopped. frames recorded: ", recording_data.size())
	if is_recording:
		var frame_data = {
			"pos": global_position,
			"anim": sprite.animation,
			"flip_h": sprite.flip_h
		}
		recording_data.append(frame_data)

func handle_playback():
	if Input.is_action_just_pressed("playback") and not recording_data.is_empty() and echo_charges > 0:
		echo_charges -= 1
		emit_signal("charges_changed", echo_charges)
		emit_signal("spawn_echo", recording_data.duplicate(), global_position)

func update_animations():
	if is_on_floor():
		sprite.play("run" if abs(velocity.x) > 0 else "idle")
	else:
		sprite.play("jump")
	
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0

func collect_artifact(artifact_node):
	has_artifact = true
	carried_artifact = artifact_node
	
	artifact_node.get_parent().remove_child(artifact_node)
	add_child(artifact_node)
	
	artifact_node.position = Vector2(0, -25)
	artifact_node.get_node("CollisionShape2D").disabled = true
	print("Artifact collected!")

func deliver_artifact():
	if carried_artifact:
		carried_artifact.queue_free()
	
	has_artifact = false
	carried_artifact = null
	
	print("Artifact delivered! Level complete!")
	get_tree().reload_current_scene()

func restore_charge():
	if echo_charges < MAX_CHARGES:
		echo_charges += 1
		emit_signal("charges_changed", echo_charges)
