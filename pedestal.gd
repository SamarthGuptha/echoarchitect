class_name Pedestal
extends Area2D
signal artifact_delivered


func _on_body_entered(body):
	if body is Player and body.has_artifact:
		body.deliver_artifact()
		emit_signal("artifact_delivered")
