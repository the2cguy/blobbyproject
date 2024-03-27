extends ColorRect
var isHelpInv:bool = true
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory") and isHelpInv:
		$AnimationPlayer.play("fadeout")
		isHelpInv = false
