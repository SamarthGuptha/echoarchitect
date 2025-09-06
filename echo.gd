class_name Echo
extends AnimatableBody2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

var playback_data = []
var current_frame = 0
var is_playing = false

func _ready():
	sync_to_physics = true

func start_playback(data: Array):
	if data.is_empty():
		queue_free()
		return
	playback_data = data
	is_playing = true
	global_position = playback_data[0].position
	animated_sprite.animation = playback_data[0].animation
	animated_sprite.flip_h = playback_data[0].flip_h


func _physics_process(delta):
	if not is_playing:
		return
	if current_frame >= playback_data.size():
		print("Echo playback finished.")
		is_playing = false
		queue_free()
		return
	var frame_data = playback_data[current_frame]
	
	global_position = frame_data.position
	animated_sprite.play(frame_data.animation)
	animated_sprite.flip_h = frame_data.flip_h
	
	current_frame += 1
