# Door.gd
# Attached to the Door StaticBody2D scene.
# Provides simple functions to open and close the door.

class_name Door
extends StaticBody2D

@onready var visual = $ColorRect

# The door is closed by default.
var is_open = false


func open_door():
	if not is_open:
		is_open = true
		# Make the door non-solid by removing it from the "world" physics layer (layer 2).
		set_collision_layer_value(2, false)
		# Change color to give visual feedback.
		visual.color = Color(1, 1, 1, 0.5) # Semi-transparent
		print("Door Opened!")

func close_door():
	if is_open:
		is_open = false
		# Make the door solid again by adding it back to the "world" physics layer (layer 2).
		set_collision_layer_value(2, true)
		visual.color = Color(1, 1, 1, 1) # Fully opaque
		print("Door Closed.")
