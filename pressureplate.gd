class_name PressurePlate
extends Area2D

signal activated
signal deactivated

@export var is_timed: bool = false
@export var active_duration: float = 3.0

@onready var visual = $ColorRect
@onready var timer = $Timer
@onready var timer_bar = $TimerBar

var bodies_on_plate = []

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	monitoring = true
	monitorable = false

	timer.timeout.connect(_on_timer_timeout)
	timer_bar.visible = is_timed
	var plate_height = visual.size.y
	timer_bar.position = Vector2(-(timer_bar.size.x / 2), -(plate_height / 2) - 5)

func _process(delta):
	if is_timed and not timer.is_stopped():
		timer_bar.update_progress(timer.time_left, active_duration)

func _on_body_entered(body):
	print("Pressure plate detected something: ", body.name)
	if not body in bodies_on_plate:
		if bodies_on_plate.is_empty():
			emit_signal("activated")
			visual.color = Color.GREEN
			print("Pressure Plate Activated!")
			if is_timed:
				timer.wait_time = active_duration
				timer.start()
		bodies_on_plate.append(body)

func _on_body_exited(body):
	if body in bodies_on_plate:
		bodies_on_plate.erase(body)
		if bodies_on_plate.is_empty():
			if not is_timed:
				emit_signal("deactivated")
				visual.color = Color.RED
				print("Pressure Plate Deactivated.")

func _on_timer_timeout():
	if bodies_on_plate.is_empty():
		emit_signal("deactivated")
		visual.color = Color.RED
		print("Pressure Plate Deactivated.")
