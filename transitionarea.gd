class_name TransitionArea
extends Area2D

signal player_entered_transition(next_scene_path)

@export_file("*.tscn") var next_scene_path: String = ""

func _ready():
	monitoring = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Player:
		if next_scene_path.is_empty():
			print("ERROR: Next Scene Path is not set on the TransitionArea.")
			return
		
		print("Player reached the end of the area. Transitioning...")
		emit_signal("player_entered_transition", next_scene_path)
