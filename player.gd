class_name Player
extends CharacterBody2D
signal spawn_echo(playback_data)
const SPEED = 250.0
const JUMP_VELOCITY = -350.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D

var recording_data = []
var is_recording = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity*delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction*SPEED
	update_animation(direction)
	handle_recording()
	if Input.is_action_just_pressed("playback"):
		if not recording_data.is_empty():
			emit_signal("spawn_echo", recording_data)
			recording_data.clear()
	move_and_slide()
func handle_recording():
	if Input.is_action_just_pressed("record"):
		is_recording = true
		recording_data.clear()
		print("Rec started...")
	if Input.is_action_just_released("record"):
		is_recording = false
		print("Recording stopped. frames recorded: ", recording_data.size())
		
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
	if direction>0:
		animated_sprite.flip_h = false
	elif direction<0:
		animated_sprite.flip_h = true
	
	if not is_on_floor():
		animated_sprite.play("jump")
	else:
		if direction !=0 :
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
			
