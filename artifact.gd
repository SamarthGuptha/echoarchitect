class_name Artifact
extends Area2D

signal collected(artifact_node)

func _ready():
	body_entered.connect(_on_body_entered)
func _on_body_entered(body):
	if body is Player:
		emit_signal("collected", self)
		print("Artifact Collected!")
		
		$CollisionShape2D.call_deferred("set_disabled", true)
	
