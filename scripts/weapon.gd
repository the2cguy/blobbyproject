extends Node2D
var weaponSpeed = 20 #Speed: rounds/second
var allowFire = true
var bullet = preload("res://models/model_default_bullet.tscn")
# Called when the node enters the scene tree for the first time.
func switchGun():
	if $ReloadTimer.is_stopped():
		#Next gun after current id
		var gunid = Global.current_weapon_id + 1
		if gunid >= len(Global.guns):
			Global.current_weapon_id = 0
		else:
			Global.current_weapon_id = gunid
		$Sprite2D.play(Global.guns[Global.current_weapon_id].name+"_idle")
		get_parent().get_parent().get_node("inventory_component").change_weapon()
func _ready():
	$Timer.timeout.connect(enableFire)
	$ReloadTimer.timeout.connect(reloadGun)
	Global.weapon = self
	$Sprite2D.play("blitz34_idle")
func enableFire():
	if Global.guns[Global.current_weapon_id].ammo > 0:
		allowFire = true
	else:
		$Sprite2D.stop()
func _process(delta):
	#Point towards the cursor
	look_at(get_global_mouse_position())
	#Automatic shooting
	if Global.guns[Global.current_weapon_id].weapon_type == "AUTO":
		if Global.guns[Global.current_weapon_id].ammo > 0 and $Timer.is_stopped() and $ReloadTimer.is_stopped():
			allowFire = true
		else:
			allowFire = false
		if Input.is_action_pressed("shoot") and allowFire:
			#Shooting animation
			$Sprite2D.play(Global.guns[Global.current_weapon_id].name+"_shooting")
			#Subtract bullets when shooting
			Global.guns[Global.current_weapon_id].ammo -= 1
			#Spawn/instance bullet
			var bullet_instance = bullet.instantiate()
			bullet_instance.global_position = $Marker2D.global_position
			get_node("/root/map_chapter1_test").add_child(bullet_instance)
			#Rounds/second mechanism
			allowFire = false
			$Timer.start(1/Global.guns[Global.current_weapon_id].ROF)
			print(Global.guns[Global.current_weapon_id].ammo)
	elif Global.guns[Global.current_weapon_id].weapon_type == "SEMIAUTO":
		if Global.guns[Global.current_weapon_id].ammo > 0 and $Timer.is_stopped() and $ReloadTimer.is_stopped():
			allowFire = true
		else:
			allowFire = false
		if Input.is_action_just_pressed("shoot") and allowFire:
			$Sprite2D.play(Global.guns[Global.current_weapon_id].name+"_shooting")
			Global.guns[Global.current_weapon_id].ammo -= 1
			var bullet_instance = bullet.instantiate()
			bullet_instance.global_position = $Marker2D.global_position
			get_node("/root/map_chapter1_test").add_child(bullet_instance)
			allowFire = false
			$Timer.start(1/Global.guns[Global.current_weapon_id].ROF)
	#If weapon is gun
	if Global.guns[Global.current_weapon_id].weapon_type == "AUTO" or Global.guns[Global.current_weapon_id].weapon_type == "SEMIAUTO":
		if Input.is_action_just_pressed("reload") and $ReloadTimer.is_stopped():
			Global.reload_progress.get_parent().show()
			$ReloadTimer.start(Global.guns[Global.current_weapon_id].reload_time)
		if Input.is_action_just_released("shoot"):
			$Sprite2D.stop()
		if Input.is_action_just_pressed("switch"):
			switchGun()
#Reload function guys
func reloadGun():
	Global.guns[Global.current_weapon_id].ammo = Global.guns[Global.current_weapon_id].capacity
	allowFire = true
	Global.reload_progress.get_parent().hide()
