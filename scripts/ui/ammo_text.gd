extends Label

@export var weapon:Node2D
func _process(delta: float) -> void:
	if Global.weapon.get_current_weapon():
		text = str(Global.weapon.get_current_weapon().ammo)
