extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reload_progress = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.weapon.get_current_weapon():
		max_value = Global.weapon.get_current_weapon().reload_time
