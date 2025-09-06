# Player.gd
# Attached to the Player CharacterBody2D node.
# Handles movement, recording, and initiating playback.

class_name Player
extends CharacterBody2D

# A signal to tell the main scene to spawn an echo.
# We pass the recorded data along with the signal.
signal spawn_echo(playback_data)

# Player movement parameters
const SPEED = 250.0
const JUMP_VELOCITY = -350.0

# Get gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Node references
@onready var animated_sprite = $AnimatedSprite2D

# Recording variables
var recording_data = []
var is_recording = false

# --- Phase 2: Echo Charges ---
const MAX_ECHO_CHARGES = 3
var echo_charges = MAX_ECHO_CHARGES
# -----------------------------

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction.
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * SPEED

	# Update sprite direction and animation
	update_animation(direction)

	# Handle recording logic
	handle_recording()
	
	# Handle playback logic
	if Input.is_action_just_pressed("playback"):
		# Check for recording data AND available charges
		if not recording_data.is_empty() and echo_charges > 0:
			echo_charges -= 1
			print("Echo spawned. Charges remaining: ", echo_charges)
			# Emit a DUPLICATE of the data so we can safely clear the original.
			emit_signal("spawn_echo", recording_data.duplicate())
			# Clear the data for the next recording
			is_recording = false # Stop recording automatically after playback
			recording_data.clear()
		elif echo_charges <= 0:
			print("Out of Echo Charges!")
		

	move_and_slide()


func handle_recording():
	if Input.is_action_just_pressed("record"):
		is_recording = not is_recording 

		if is_recording:

			recording_data.clear()
			print("Recording started...")
		else:

			print("Recording stopped. Frames recorded: ", recording_data.size())


	if is_recording:
		record_current_frame()

func record_current_frame():
	var frame_data = {
		"position": global_position,
		"animation": animated_sprite.animation,
		"flip_h": animated_sprite.flip_h
	}
	recording_data.append(frame_data)


func update_animation(direction):
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if not is_on_floor():
		animated_sprite.play("jump")
	else:
		if direction != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")

func _on_echo_destroyed():
	if echo_charges < MAX_ECHO_CHARGES:
		echo_charges += 1
		print("Echo destroyed. Charge restored. Charges: ", echo_charges)
