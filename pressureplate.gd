# PressurePlate.gd
# Attached to the PressurePlate Area2D scene.
# Detects bodies entering/leaving and emits signals when its state changes.

class_name PressurePlate
extends Area2D

# Signal emitted when the first body enters.
signal activated
# Signal emitted when the last body leaves.
signal deactivated

@onready var visual = $ColorRect

# A list to keep track of all bodies currently on the plate.
var bodies_on_plate = []

func _ready():
	# Connect the Area2D's built-in signals to our functions.
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Set the monitoring properties. We want this area to detect
	# both the player and the solid echoes.
	monitoring = true
	monitorable = false


func _on_body_entered(body):
	#
	print("Pressure plate detected something: ", body.name)

	if not body in bodies_on_plate:
		
		if bodies_on_plate.is_empty():
			emit_signal("activated")
			visual.color = Color.GREEN 
			print("Pressure Plate Activated!")
			
		bodies_on_plate.append(body)


func _on_body_exited(body):
	if body in bodies_on_plate:
		bodies_on_plate.erase(body)
		
		
		if bodies_on_plate.is_empty():
			emit_signal("deactivated")
			visual.color = Color.RED 
			print("Pressure Plate Deactivated.")
