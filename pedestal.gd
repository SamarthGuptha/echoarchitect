class_name Pedestal
extends Area2D

signal artifact_delivered

func _ready():
	monitoring = true

func _on_body_entered(body):
	# THIS IS THE TEST LINE:
	print("Pedestal detected a body named: ", body.name)
	
	if body is Player:
		print("It was the Player! Emitting signal.")
		emit_signal("artifact_delivered")
