extends Label


func _process(delta: float) -> void:
	text = str(Global.guns[Global.current_weapon_id].ammo)
