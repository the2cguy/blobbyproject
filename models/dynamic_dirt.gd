extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not $AnimatedSprite2D.is_playing():
		if body.velocity.x > 5.0:
			$AnimatedSprite2D.play("default")
