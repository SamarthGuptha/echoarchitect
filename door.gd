class_name Door
extends StaticBody2D

@onready var collision_shape = $CollisionShape2D
@onready var visual = $ColorRect

var is_open = false
func open_door():
	if not is_open:
		is_open = true
		collision_shape.disabled = true
		visual.color = Color(1, 1, 1, 0.5)
		print("Door open")
func close_door():
	if is_open:
		is_open = false
		collision_shape.disabled = false
		visual.color = Color(1,1,1,1)
		print('Door Closed')
