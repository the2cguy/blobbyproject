extends CharacterBody2D
@onready var blobby_detect:Area2D = $Area2D
@onready var blobby_seat:Marker2D = $blobby_seat
var moving:bool = false
func _process(delta: float) -> void:
	for i in blobby_detect.get_overlapping_bodies():
		if i.name == "model_player":
			i.global_position = blobby_seat.global_position
			i.freeze_movement = true
			i.reparent(self)
			moving = true
	if moving:
		velocity = Vector2.LEFT * 200
	move_and_slide()
