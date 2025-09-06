class_name Artifact
extends Area2D

signal collected(artifact_node)

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Player and not body.has_artifact:
		emit_signal("collected", self)
