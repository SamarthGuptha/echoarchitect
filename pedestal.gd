class_name Pedestal
extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
func _on_body_entered(body):
	if body is Player and body.has_artifact:
		print("Level Complete.")
		get_tree().reload_current_scene()
