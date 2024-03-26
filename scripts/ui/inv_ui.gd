extends Control

@onready var inv:Inv = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/HBoxContainer.get_children()
@export var playerdata:PlayerData
var is_open = false

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
func select_slot(id:int):
	slots[id].select()
	print("ID:", id)
	for i in len(slots):
		if i != playerdata.weaponid:
			slots[i].unselect()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else:
			open()
	if !slots[playerdata.weaponid].is_hover:
		select_slot(playerdata.weaponid)
func open():
	is_open = true
	visible = true
	
func close():
	is_open = false
	visible = false
