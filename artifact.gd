class_name Artifact
extends Area2D

signal collected(artifact_node)

func _ready():
	monitoring = true

func _on_body_entered(body):
	# THIS IS THE TEST LINE:
	print("Artifact detected a body named: ", body.name)
	
	if body is Player:
		emit_signal("collected", self)
