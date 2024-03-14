extends Node2D

@export var health:float
signal damageIncoming
func damage(amount:float):
	health -= amount
	damageIncoming.emit()

func _process(delta: float) -> void:
	if health <= 0:
		get_parent().queue_free()
