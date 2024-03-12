extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reload_progress = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	max_value = Global.guns[Global.current_weapon_id].reload_time
	value = Global.weapon.get_node("ReloadTimer").time_left
	
