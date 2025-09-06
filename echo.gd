class_name Echo
extends AnimatableBody2D
signal playback_finished
var playback_data: Array[Dictionary] = []
var current_frame: int = 0

func set_playback_data(data: Array[Dictionary]):
	playback_data = data

func _physics_process(delta):
	if playback_data.is_empty() or current_frame >= playback_data.size():
		if not is_queued_for_deletion():
			emit_signal("playback_finished")
			queue_free()
		return
	var frame_data = playback_data[current_frame]
	global_position = frame_data["pos"]
	var sprite = get_node("AnimatedSprite2D")
	sprite.animation = frame_data["anim"]
	sprite.flip_h = frame_data["flip_h"]

	current_frame += 1
