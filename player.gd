class_name Player
extends CharacterBody2D

signal spawn_echo(playback_data, spawn_pos)
signal charges_changed(new_charge_count)

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D
var recording_data: Array[Dictionary] = []
var is_recording: bool = false
var echo_charges: int = 3
var carried_artifact = null

func _physics_process(delta):
	handle_movement(delta)
	handle_animation()
	handle_recording()
	handle_playback()

func handle_movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	move_and_slide()

func handle_animation():
	if not is_on_floor():
		sprite.animation = "jump"
	else:
		if velocity.x != 0:
			sprite.animation = "run"
			sprite.flip_h = velocity.x < 0
		else:
			sprite.animation = "idle"

func handle_recording():
	if Input.is_action_just_pressed("record"):
		is_recording = not is_recording
		if is_recording:
			print("Rec started...")
			recording_data.clear()
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
		emit_signal("spawn_echo", recording_data.duplicate(), global_position)
		echo_charges -= 1
		emit_signal("charges_changed", echo_charges)

func restore_charge():
	echo_charges = min(echo_charges + 1, 3)
	emit_signal("charges_changed", echo_charges)
	print("Charge restored. Current charges: ", echo_charges)

func collect_artifact(artifact_node):
	if carried_artifact:
		return
	carried_artifact = artifact_node
	call_deferred("_deferred_attach_artifact", artifact_node)

func _deferred_attach_artifact(artifact_node):
	artifact_node.get_parent().remove_child(artifact_node)
	add_child(artifact_node)
	artifact_node.position = Vector2(0, -40)
	var collision_shape = artifact_node.get_node("CollisionShape2D")
	collision_shape.set_deferred("disabled", true)

func deliver_artifact():
	if carried_artifact:
		carried_artifact.queue_free()
		carried_artifact = null
		return true
	return false

func has_artifact():
	return carried_artifact != null
