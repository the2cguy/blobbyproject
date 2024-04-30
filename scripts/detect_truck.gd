extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Truck":
		get_parent().get_node("PhantomCamera2D").priority = 0
