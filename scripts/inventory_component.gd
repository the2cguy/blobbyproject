extends Node2D
var itembtn = preload("res://ui/items_btn.tscn")
@export var items_ui:HBoxContainer
@export var inventory:Array[invItem]
@export var weapons:Array[weaponItem]
func loadGuns():
	Global.guns = []
	var k = 0
	for i in weapons:
		if i.weapon_type == "SEMIAUTO":
			appendToInventoryUI(load("res://inventory/icons/semiauto.png"), k)
			Global.guns.append(i)
		elif i.weapon_type == "AUTO":
			Global.guns.append(i)
			appendToInventoryUI(load("res://inventory/icons/auto.png"), k)
		k += 1
func _ready() -> void:
	loadGuns()
func appendToInventoryUI(icon:Texture2D, gunid):
	var item_btn = itembtn.instantiate()
	item_btn.change_icon(icon)
	item_btn.gun_id = gunid
	items_ui.add_child(item_btn)
func change_weapon():
	for i in items_ui.get_children():
		i.modulate = Color("FFFFFF")
	items_ui.get_child(Global.current_weapon_id).modulate = Color("#9d9d9d")
