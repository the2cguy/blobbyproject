extends Node2D

var weaponID = 0
var last_weaponID = 0
@onready var weapons_node = $Node2D
@export var inv:Inv
@export var playerdata:PlayerData
# Normal Init
var weapon_type = ""
func _ready():
	Global.weapon = self
	load_weapons()

func load_weapons():
	for i in range(len(inv.slots)):
		if inv.slots[i].item != null:
			if inv.slots[i].item.is_weapon:
				var weapon_instance = inv.slots[i].item.weapon.instantiate()
				weapons_node.add_child(weapon_instance)
			#i.item.weapon.ammo

func get_current_weapon():
	if weapons_node.get_children() and weaponID != -2:
		return weapons_node.get_children()[weaponID]
	else:
		return null
func add_weapon(weapon):
	var k = weapon.instantiate()
	k.hide()
	weapons_node.add_child(k)

func set_weapon(id):
	if id != -2:
		last_weaponID = weaponID
		print(last_weaponID)
		weaponID = id
		playerdata.weaponid = weaponID
		weapons_node.get_children()[last_weaponID].hide()
		weapons_node.get_children()[last_weaponID].current_weapon = false
		weapons_node.get_children()[weaponID].show()
		weapons_node.get_children()[weaponID].current_weapon = true
		weapon_type = weapons_node.get_children()[weaponID].weapon_type
func set_weapon_name(name:String):
	for i in len(weapons_node.get_children()):
		if weapons_node.get_children()[i].name == name:
			set_weapon(i)
			print(i)
			break
func _process(delta):
	if weapon_type == "AUTO":
		if Input.is_action_pressed("shoot"):
			weapons_node.get_children()[weaponID].shoot()
		if Input.is_action_just_pressed("reload"):
			get_current_weapon().start_reload()
	elif weapon_type == "SEMIAUTO":
		if Input.is_action_just_pressed("shoot"):
			get_current_weapon().shoot()
		if Input.is_action_just_pressed("reload"):
			get_current_weapon().start_reload()
	#if Input.is_action_just_pressed("switch"):
		#_nextWeapon()
