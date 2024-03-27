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
		if i != playerdata.weaponid and slots[i].is_hover != false:
			slots[i].unselect()
func _process(delta: float) -> void:
	visible = true
	if Input.is_action_just_pressed("inventory") and not $AnimationPlayer.is_playing():
		if is_open:
			close()
		else:
			open()
	if !slots[playerdata.weaponid].is_hover:
		select_slot(playerdata.weaponid)
func open():
	if !$AnimationPlayer.is_playing():$AnimationPlayer.play("open")
	is_open = true
	
func close():
	if !$AnimationPlayer.is_playing():$AnimationPlayer.play("closes")
	is_open = false
