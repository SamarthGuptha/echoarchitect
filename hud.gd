class_name HUD
extends CanvasLayer

@onready var charge_label = $Label
func update_charge_display(charge_count: int):
	charge_label.text = "Echo Charges: %s"%charge_count
