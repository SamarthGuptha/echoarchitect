class_name Player
extends CharacterBody2D
signal spawn_echo(playback_data)

const SPEED = 250.0
const JUMP_VELOCITY = -350.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D
var recording_data = []
var is_recording = false

# --- Phase 2: Echo Charges ---
const MAX_ECHO_CHARGES = 3
var echo_charges = MAX_ECHO_CHARGES
# -----------------------------

# --- Phase 3: Artifact State ---
var has_artifact = false
var carried_artifact = null
# -------------------------------


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
			emit_signal("spawn_echo", recording_data.duplicate())
		elif echo_charges <= 0:
			print("Out of Echo Charges!")
		
	move_and_slide()
	
	# --- Phase 3: Make artifact follow player ---
	if has_artifact and carried_artifact:
		# Position the artifact slightly above the player's head.
		carried_artifact.global_position = global_position + Vector2(0, -40)
	# --------------------------------------------


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

# --- Phase 3: Function to handle picking up an artifact ---
func _on_artifact_collected(artifact_node):
	has_artifact = true
	carried_artifact = artifact_node
	# We don't make it a child, we just control its position manually.
	# This prevents it from interfering with player physics.
# ------------------------------------------------------------
