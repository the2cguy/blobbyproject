extends CharacterBody2D

@export var speed = 400.0

func _process(delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = lerp(velocity, dir * speed, 0.02)
	if dir:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
	if get_global_mouse_position().x < global_position.x:
		$AnimatedSprite2D.scale.x = -1
	else:
		$AnimatedSprite2D.scale.x = 1
	move_and_slide()
	
