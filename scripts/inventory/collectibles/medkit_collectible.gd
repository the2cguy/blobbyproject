extends StaticBody2D

@export var item:InvItem
var player = null




func _on_collectible_detect_body_entered(body: Node2D) -> void:
	if body.name == "model_player":
		player = body
		player.collect(item)
		await get_tree().create_timer(0.1).timeout
		self.queue_free()
