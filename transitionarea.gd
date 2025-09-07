class_name TransitionArea
extends Area2D

signal player_entered_transition(next_scene_path)
var next_scene_path: String = "res://l2.tscn"

func _read():
	monitoring = true
	body_entered.connect(_on_body_entered)
func _on_body_entered(body):
	if body is Player:
		if next_scene_path.is_empty():
			print("ERROR: nextscenepath is empty.")
			return
		print("player reached end of area... transitioning")
		emit_signal("player_entered_transition", next_scene_path)
