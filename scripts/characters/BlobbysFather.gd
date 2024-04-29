extends CharacterBody2D


func _on_dialog_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not Dialogic.current_timeline:
		body.cutscene("level1_001_blobbyfather")
