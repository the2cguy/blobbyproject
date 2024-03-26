extends Control

@onready var inv:Inv = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/HBoxContainer.get_children()
var is_open = false

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else:
			open()
func open():
	is_open = true
	visible = true
	
func close():
	is_open = false
	visible = false
