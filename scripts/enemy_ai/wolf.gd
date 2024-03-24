extends CharacterBody2D
var isAware:bool = false
var player:Node2D
var knockback = Vector2(0, 0)
var roamDirection:float
var steering = Vector2.ZERO
@export_enum("b", "a") var k:String
@export_range(100, 2000) var speed:float
@export var navAgent:NavigationAgent2D
@export_range(0.0, 10.0) var knockback_multiplier:float
var current_path: Array[Vector2i]
var health_bar:ProgressBar
var anger_level = 1.5
func damageplayer():
	for i in $Area2D.get_overlapping_bodies():
		if i.name == "model_player":
			i.get_node("health_component").damage(0.5)
	$attack_timer.wait_time = RandomNumberGenerator.new().randf_range(0.4, 1.2)
	$attack_timer.start()
func _ready() -> void:
	health_bar = $health_bar
	$attack_timer.timeout.connect(damageplayer)
func knockbackFunc(direction:Vector2):
	velocity = direction * get_process_delta_time() * 100
	$GPUParticles2D.rotation =	(direction.angle())
func _physics_process(delta: float) -> void:
	# If enemy is aware then moves toward the player.
	if isAware:
		$gizmo_player.look_at(Global.player.global_position)	
		$gizmo_player.rotate(deg_to_rad(45))
		var direction = Vector2.RIGHT.rotated($gizmo_player.rotation)
		velocity = velocity.move_toward((direction * 80), 200*delta)
	# If enemy is NOT AWARE then roam around.
	else:
		velocity = velocity.move_toward(Vector2.RIGHT.rotated(roamDirection) * 50, 50*delta)
	move_and_slide()
	
	health_bar.value = $health_component.health
func _on_health_component_damage_incoming() -> void:
	isAware = true
	$animation.play("hurt")
	$GPUParticles2D.emitting = true
	anger_level += 0.2
	if $attack_timer.is_stopped():
		$attack_timer.start()

func _on_roam_timer_timeout() -> void:
	roamDirection = deg_to_rad(RandomNumberGenerator.new().randf_range(0, 360))
