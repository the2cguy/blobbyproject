extends Label

@export var weapon:Node2D
func _process(delta: float) -> void:
	text = str(weapon.weapons[weapon.weaponID].ammo)
