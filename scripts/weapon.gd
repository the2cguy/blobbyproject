extends Node2D

var weaponID = 0
var weapons:Array[weaponItem]
var weaponType = ["SEMIAUTO", "AUTO", "MELEE"]
var shootDelayTimer:Timer = Timer.new()
var reloadTimer:Timer = Timer.new()
var allowFire = true
var bullet = preload("res://models/model_default_bullet.tscn")
var blitz34:weaponItem = preload("res://inventory/weapons/blitz34.tres")
var stick:weaponItem = preload("res://inventory/weapons/stick.tres")
@export var reloadBar:ProgressBar
@export var hurtArea:Area2D
# Called when the node enters the scene tree for the first time.
# Melee Function
func _attack():
	$Sprite2D.play(weapons[weaponID].name+"_melee")
	for i in hurtArea.get_overlapping_bodies():
		if i.name != "model_player":
			if i.has_node("health_component"):
				i.get_node("health_component").damage(0.5)
			if i.has_method("knockbackFunc"):
				i.knockbackFunc(Vector2.RIGHT.rotated(rotation) * weapons[weaponID].knockback)
# Guns Function
func reduceAmmo(amount:int):
	weapons[weaponID].ammo -= amount
	print(weapons[weaponID].ammo)
func _fire():
	if weapons[weaponID].ammo > 0 and shootDelayTimer.is_stopped() and reloadTimer.is_stopped():
		allowFire = true
	if allowFire:
		reduceAmmo(1)
		$Sprite2D.play(weapons[weaponID].name+"_shooting")
		# Spawn Bullet
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = $Marker2D.global_position
		get_node("/root/map_chapter1_test").add_child(bullet_instance)
		# Delay Fire
		allowFire = false
		shootDelayTimer.start(1.0/weapons[weaponID].ROF)
	return
func _reload():
	weapons[weaponID].ammo = weapons[weaponID].capacity
	# Hide Reload Bar
	reloadBar.get_parent().hide()
# Global Functions
func _nextWeapon():
	weaponID += 1
	if weaponID > (len(weapons) - 1):
		weaponID = 0
	$Sprite2D.play(weapons[weaponID].name+"_idle")
func _idleWeapon():
	$Sprite2D.play(weapons[weaponID].name+"_idle")
# Normal Init
func _ready():
	# Init Timers
	shootDelayTimer.one_shot = true
	add_child(shootDelayTimer)
	reloadTimer.one_shot = true
	add_child(reloadTimer)
	reloadTimer.timeout.connect(_reload)
	# Add default weapon
	weapons.append(blitz34.duplicate())
	weapons.append(stick.duplicate())
	Global.weapon = weapons
	_nextWeapon()
func _process(delta):
	# Update reload bar
	reloadBar.value = reloadTimer.time_left
	#Point towards the cursor, if weaponType is SEMIAUTO or AUTO
	if weapons[weaponID].weapon_type == "SEMIAUTO" or weapons[weaponID].weapon_type == "AUTO":
		look_at(get_global_mouse_position())
		if Input.is_action_just_pressed("reload") and reloadTimer.is_stopped():
			reloadTimer.start(weapons[weaponID].reload_time)
			reloadBar.get_parent().show()	
	#Automatic shooting
	if weapons[weaponID].weapon_type == "AUTO":
		if Input.is_action_pressed("shoot"):
			_fire()
		elif Input.is_action_just_released("shoot"):
			_idleWeapon()
	#Semiautomatic shooting
	if weapons[weaponID].weapon_type == "SEMIAUTO":
		if Input.is_action_just_pressed("shoot"):
			_fire()
	#If weapon is melee
	if weapons[weaponID].weapon_type == "MELEE": 
		if Input.is_action_just_pressed("shoot"):
			_attack()
	if Input.is_action_just_pressed("switch"):
			_nextWeapon()
