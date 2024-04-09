extends Node2D
@onready var line:Line2D = $Line2D
@onready var raycast:RayCast2D = $RayCast2D
@export var progress = 0
@onready var stun_area:Area2D = $TaserSting/StunArea
var target_position:Vector2
var taser_state = "close"
signal retracted
func update_taser_position(pos):
	target_position = line.to_local(pos)
func _process(delta: float) -> void:
	# set end point of the line to be the player's position with progress animation
	line.set_point_position(1, target_position*progress)
	# the taser sting follows the end of the line
	$TaserSting.global_position = line.to_global(target_position*progress)
	#print($TaserSting.global_position, " ++ ", get_global_mouse_position())
	# taser sting rotates according to the line
	$TaserSting.rotation = target_position.angle() + deg_to_rad(-90)
	# raycast target to player
	raycast.target_position = target_position
	# if the raycast collides with object then retract taser.
	if raycast.get_collider():
		# if touch object besides player and taser opened, remove taser
		if raycast.get_collider().name != "model_player" and taser_state == "open":
			#print(raycast.get_collider().name)
			retract()
	if get_parent().global_position.distance_to(Global.player.global_position) > 350.0:
		retract()
func shoot():
	# If player in LOS and taser closed, shoot taser
	print(raycast.get_collider())
	if raycast.get_collider():
		print(raycast.get_collider().name)
		if raycast.get_collider().name == "model_player" and taser_state == "close":
			taser_state = "open"
			$AnimationPlayer.play("shoot")
			raycast.get_collider().slowmove = true
func retract():
	# If taser opened, then retract
	if taser_state == "open":
		taser_state = "close"
		$AnimationPlayer.play("retract")
		retracted.emit()
		Global.player.slowmove = false
		print("Slowmove false")
func stun():
	for body in stun_area.get_overlapping_bodies():
		if body.name == "model_player":
			body.get_node("health_component").damage(0.1)
			print("Slowmove true")
