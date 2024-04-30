extends CharacterBody2D

class_name truck

var speed = 70
var moving_direction:Vector2 = Vector2.LEFT
var camdelay = Timer.new()

func _ready() -> void:
	velocity = speed * moving_direction
	camdelay.one_shot = true
	camdelay.wait_time = 1.0
	camdelay.timeout.connect(setcam)
	add_child(camdelay)
	
func _process(delta: float) -> void:
	move_and_slide()

func setcam():
	get_parent().get_node("PlayerCam").priority = 2
	Global.player.can_move = true

func _on_truck_detect_area_entered(area: Area2D) -> void:
	if area.name == "TruckDetect":
		Global.player.reparent(get_parent())
		$AnimationTree.play("a")
		camdelay.start()
