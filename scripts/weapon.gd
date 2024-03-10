extends Node2D
var weaponType = "AUTO"
var weaponSpeed = 20 #Speed: rounds/second
var currentWeapon = "blitz34"
var allowFire = true
var bullet = preload("res://models/model_default_bullet.tscn")
# Called when the node enters the scene tree for the first time.
func switchGun():
	if $ReloadTimer.is_stopped():
		var gunid = Global.guns.keys().find(currentWeapon, 0)+1
		if gunid >= len(Global.guns.keys()):
			currentWeapon = Global.guns.keys()[0]
		else:
			currentWeapon = Global.guns.keys()[gunid]
		weaponType = Global.guns[currentWeapon]
		$Sprite2D.play(currentWeapon+"_idle")
func _ready():
	$Timer.timeout.connect(enableFire)
	$ReloadTimer.timeout.connect(reloadGun)
	$Sprite2D.play(currentWeapon+"_idle")
func enableFire():
	if Global.gunAmmo[currentWeapon] > 0:
		allowFire = true
	else:
		$Sprite2D.stop()
func _process(delta):
	#Point towards the cursor
	look_at(get_global_mouse_position())
	#Automatic shooting
	if weaponType == "AUTO":
		if Global.gunAmmo[currentWeapon] > 0 and $Timer.is_stopped():
			allowFire = true
		else:
			allowFire = false
		if Input.is_action_pressed("shoot") and allowFire:
			#Shooting animation
			$Sprite2D.play(currentWeapon+"_shooting")
			#Subtract bullets when shooting
			Global.gunAmmo[currentWeapon] -= 1
			#Spawn/instance bullet
			var bullet_instance = bullet.instantiate()
			bullet_instance.global_position = $Marker2D.global_position
			get_node("/root/map_chapter1_test").add_child(bullet_instance)
			#Rounds/second mechanism
			allowFire = false
			$Timer.start(1/Global.gunROF[currentWeapon])
			print(Global.gunAmmo)
	elif weaponType == "SEMIAUTO":
		if Global.gunAmmo[currentWeapon] > 0 and $Timer.is_stopped():
			allowFire = true
		else:
			allowFire = false
		if Input.is_action_just_pressed("shoot") and allowFire:
			$Sprite2D.play(currentWeapon+"_shooting")
			Global.gunAmmo[currentWeapon] -= 1
			var bullet_instance = bullet.instantiate()
			bullet_instance.global_position = $Marker2D.global_position
			get_node("/root/map_chapter1_test").add_child(bullet_instance)
			allowFire = false
			$Timer.start(1/Global.gunROF[currentWeapon])
	#If weapon is gun
	if weaponType == "AUTO" or weaponType == "SEMIAUTO":
		if Input.is_action_just_pressed("reload") and $ReloadTimer.is_stopped():
			$ReloadTimer.start(Global.gunReloadTime[currentWeapon])
		if Input.is_action_just_released("shoot"):
			$Sprite2D.stop()
		if Input.is_action_just_pressed("switch"):
			switchGun()
#Reload function guys
func reloadGun():
	Global.gunAmmo[currentWeapon] = Global.gunCapacity[currentWeapon]
	allowFire = true
	print("RELOAD")
