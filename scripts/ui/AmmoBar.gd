extends TextureProgressBar

var max_ammo:int

func update_ammo(ammo):
	value = remap(ammo, 0, max_ammo, 21, 51)
	$AnimationPlayer.play("shake")
