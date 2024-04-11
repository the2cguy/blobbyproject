extends Control

@onready var inv:Inv = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/HBoxContainer.get_children()
@export var playerdata:PlayerData
var is_open = false
var current_slot_id:int = 0
func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
func select_slot(id:int):
	if not slots[id].is_hover:
		slots[id].select()
	for i in len(slots):
		if not i == id and slots[i].is_hover == true:
			slots[i].unselect()
func _process(delta: float) -> void:
	visible = true
	if Input.is_action_just_pressed("inventory") and not $AnimationPlayer.is_playing():
		if is_open:
			close()
		else:
			open()
	select_slot(current_slot_id)
	if Input.is_action_just_pressed("switch"):
		if current_slot_id < (len(slots) - 1):
			current_slot_id += 1
		else:
			current_slot_id = 0
		if inv.slots[current_slot_id].item:
			if inv.slots[current_slot_id].item.is_weapon:
				Global.player.get_node("weapon").set_weapon_name(inv.slots[current_slot_id].item.name)
			else:
				Global.player.get_node("weapon").set_weapon(-2)
		else:
			Global.player.get_node("weapon").set_weapon(-2)
			
func open():
	if !$AnimationPlayer.is_playing():$AnimationPlayer.play("open")
	is_open = true
	
func close():
	if !$AnimationPlayer.is_playing():$AnimationPlayer.play("closes")
	is_open = false
