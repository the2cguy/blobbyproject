extends CharacterBody2D
@export var Player:Node2D
var knockback = Vector2(0, 0)
var roam_direction:float
@export_range(100, 2000) var speed:float
@export_range(0.0, 10.0) var knockback_multiplier:float
@onready var health_bar:ProgressBar = $health_bar
@onready var raycast:RayCast2D = $RayCast2D
var anger_level = 1.5
var state:State = State.new()
var stun:bool = true
const MAXLOS = 200
@onready var detect_player:Area2D = $detect_area
@onready var attack_player:Area2D = $attack_area
var player_location_timer:Timer = Timer.new()
var player_location:Vector2

func seek_steering() -> Vector2:
	var desired_velocity:Vector2 = (Player.global_position - global_position).normalized() * 100
	return desired_velocity - velocity
class State:
	var states = [
		"idle",
		"aware",
		"searching"
	]
	var current_state = "idle"
	func set_state(state:String):
		current_state = state
		
	func idle():
		return current_state == "idle"
	
	func aware():
		return current_state == "aware"
	
	func searching():
		return current_state == "searching"
		
func set_player_location():
	player_location = Player.position
	if state.aware():
		player_location_timer.start()
func detect_LOS():
	raycast.target_position = global_position.direction_to(player_location) * MAXLOS
	var isLOS = false
	if raycast.is_colliding():
		var obj_collide = raycast.get_collider()
		if obj_collide.name == "model_player":
			isLOS = true
			#print("detect LOS")
		##print(obj_collide.name)
	return isLOS
func damage_player():
	for i in attack_player.get_overlapping_bodies():
		if i.name == "model_player":
			i.get_node("health_component").damage(0.5)
	$attack_timer.wait_time = RandomNumberGenerator.new().randf_range(0.4, 1.2)
	$attack_timer.start()
func _ready() -> void:
	$attack_timer.timeout.connect(damage_player)
	player_location_timer.one_shot = true
	player_location_timer.wait_time = 0.70
	add_child(player_location_timer)
	player_location_timer.timeout.connect(set_player_location)
	
func knockbackFunc(direction:Vector2):
	knockback = direction.normalized() * 100
	$GPUParticles2D.rotation =	(direction.angle())
	$animation.play("hurt")
	
func avoidance_force() -> Vector2:
	$avoidance.rotation = velocity.angle()
	for i in $avoidance.get_children():
		i.target_position.x = 100 * 4
		if i.is_colliding() and i.name != "model_player":
			var obstacle = i.get_collider()
			return (global_position + velocity - i.target_position).normalized() * 60
	return Vector2.ZERO
			

func _physics_process(delta: float) -> void:
	
	# If enemy is AWARE then moves toward the player.
	if state.idle():
		for i in detect_player.get_overlapping_bodies():
			if i.name == "model_player":
				Player = i
				if player_location_timer.is_stopped(): player_location_timer.start()
				if detect_LOS():
					state.set_state("aware")
		velocity = velocity.move_toward(Vector2.RIGHT.rotated(roam_direction) * 40, delta * 40)
	if state.aware():
		var MAXSPEED = 50
		#print("muahahadwdwdwdwdwdw")
		var steering:Vector2 = Vector2.ZERO
		steering += seek_steering()
		steering = steering.clamp(Vector2(-MAXSPEED, -MAXSPEED), Vector2(MAXSPEED, MAXSPEED))
		steering += knockback
		knockback *= 0.92
		velocity += steering
		#velocity = velocity.clamp(Vector2(-MAXSPEED, -MAXSPEED), Vector2(MAXSPEED, MAXSPEED))
		$gizmo_player.look_at(Global.player.global_position)	
		$gizmo_player.rotate(deg_to_rad(45))
		var direction = Vector2.RIGHT.rotated($gizmo_player.rotation)
		velocity = velocity.move_toward(direction * 50, 100*delta)
		if not detect_LOS():
			state.set_state("idle")
		#print(detect_LOS())

		
	move_and_slide()
	health_bar.value = $health_component.health

func _on_health_component_damage_incoming() -> void:
	# set state to AWARE
	state.set_state("aware")
	Player = Global.player
	$animation.play("hurt")
	$GPUParticles2D.emitting = true
	anger_level += 0.2
	if $attack_timer.is_stopped():
		$attack_timer.start()
	if player_location_timer.is_stopped():
		player_location_timer.start()

func _on_roam_timer_timeout() -> void:
	roam_direction = deg_to_rad(RandomNumberGenerator.new().randf_range(0, 360))
