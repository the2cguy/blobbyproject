extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.UI = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()+Vector2(-20, -20)
	if Global.weapon.get_current_weapon() != null:
		if Global.weapon.get_current_weapon().weapon_type == "AUTO":
			if Input.is_action_pressed("shoot"):
				$AnimationPlayer.play("crosshair_rotation")
			else:
				$AnimationPlayer.stop()
		elif Global.weapon.get_current_weapon().weapon_type == "SEMIAUTO":
			if Input.is_action_just_pressed("shoot"):
				$AnimationPlayer.play("crosshair_shoot")
		else :
			if Input.is_action_just_pressed("shoot"):
				$AnimationPlayer.play("crosshair_shoot")
