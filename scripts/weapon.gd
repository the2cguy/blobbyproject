extends Node2D
var weaponType = "AUTO"
var weaponSpeed = 20 #Speed: rounds/second
var allowFire = true
var bullet = preload("res://models/model_default_bullet.tscn")
# Called when the node enters the scene tree for the first time.
func switchGun():
	if $ReloadTimer.is_stopped():
		var gunid = Global.guns.keys().find(Global.currentWeapon, 0)+1
		if gunid >= len(Global.guns.keys()):
			Global.currentWeapon = Global.guns.keys()[0]
		else:
			Global.currentWeapon = Global.guns.keys()[gunid]
		weaponType = Global.guns[Global.currentWeapon]
		$Sprite2D.play(Global.currentWeapon+"_idle")
func _ready():
	$Timer.timeout.connect(enableFire)
	$ReloadTimer.timeout.connect(reloadGun)
	$Sprite2D.play(Global.currentWeapon+"_idle")
	Global.weapon = self
func enableFire():
	if Global.gunAmmo[Global.currentWeapon] > 0:
		allowFire = true
	else:
		$Sprite2D.stop()
func _process(delta):
	#Point towards the cursor
	look_at(get_global_mouse_position())
	#Automatic shooting
	if weaponType == "AUTO":
		if Global.gunAmmo[Global.currentWeapon] > 0 and $Timer.is_stopped() and $ReloadTimer.is_stopped():
			allowFire = true
		else:
			allowFire = false
		if Input.is_action_pressed("shoot") and allowFire:
			#Shooting animation
			$Sprite2D.play(Global.currentWeapon+"_shooting")
			#Subtract bullets when shooting
			Global.gunAmmo[Global.currentWeapon] -= 1
			#Spawn/instance bullet
			var bullet_instance = bullet.instantiate()
			bullet_instance.global_position = $Marker2D.global_position
			get_node("/root/map_chapter1_test").add_child(bullet_instance)
			#Rounds/second mechanism
			allowFire = false
			$Timer.start(1/Global.gunROF[Global.currentWeapon])
			print(Global.gunAmmo)
	elif weaponType == "SEMIAUTO":
		if Global.gunAmmo[Global.currentWeapon] > 0 and $Timer.is_stopped() and $ReloadTimer.is_stopped():
			allowFire = true
		else:
			allowFire = false
		if Input.is_action_just_pressed("shoot") and allowFire:
			$Sprite2D.play(Global.currentWeapon+"_shooting")
			Global.gunAmmo[Global.currentWeapon] -= 1
			var bullet_instance = bullet.instantiate()
			bullet_instance.global_position = $Marker2D.global_position
			get_node("/root/map_chapter1_test").add_child(bullet_instance)
			allowFire = false
			$Timer.start(1/Global.gunROF[Global.currentWeapon])
	#If weapon is gun
	if weaponType == "AUTO" or weaponType == "SEMIAUTO":
		if Input.is_action_just_pressed("reload") and $ReloadTimer.is_stopped():
			Global.reload_progress.get_parent().show()
			$ReloadTimer.start(Global.gunReloadTime[Global.currentWeapon])
		if Input.is_action_just_released("shoot"):
			$Sprite2D.stop()
		if Input.is_action_just_pressed("switch"):
			switchGun()
#Reload function guys
func reloadGun():
	Global.gunAmmo[Global.currentWeapon] = Global.gunCapacity[Global.currentWeapon]
	allowFire = true
	Global.reload_progress.get_parent().hide()
