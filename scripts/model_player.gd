extends CharacterBody2D

@export var speed = 400.0
@export var sprint_speed:float
@onready var noise = FastNoiseLite.new()
@onready var navreg:NavigationRegion2D = get_parent().get_node("NavigationRegion2D")
var isShake = false
var noise_y = 0.0
var amount:int
var freeze_movement:bool = false
var stun_time:Timer = Timer.new()
var slowmove:bool = false
@export var inv:Inv
func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	stun_time.wait_time = RandomNumberGenerator.new().randf_range(0.7, 1.4)
	stun_time.one_shot = true
	add_child(stun_time)
	randomize()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	Global.player = self
func _process(delta):
	#print(stun_time.is_stopped())
	if not freeze_movement:
		var dir = Input.get_vector("left", "right", "up", "down")
		if Input.is_action_pressed("sprint") and not slowmove:
			velocity = lerp(velocity, dir * sprint_speed, 0.2)
		elif slowmove:
			velocity = lerp(velocity, dir * speed * 0.5, 0.2)
		elif not slowmove:
			velocity = lerp(velocity, dir * speed, 0.2)
		if dir:
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")
		move_and_slide()
	if get_global_mouse_position().x < global_position.x:
		$AnimatedSprite2D.scale.x = -1
	else:
		$AnimatedSprite2D.scale.x = 1
	Global.health = $health_component.health
	if isShake:
		$Camera2D.offset = Vector2(noise.get_noise_2d(noise.seed, noise_y) * amount * 2, noise.get_noise_2d(noise.seed, noise_y) * amount)
		noise_y += 1
		amount -= 1 * delta
	if Input.is_action_just_pressed("next"):
		navreg.bake_navigation_polygon(true)
	if freeze_movement:
		$Camera2D.drag_horizontal_enabled = false
		$Camera2D.drag_vertical_enabled = false

func _on_health_component_damage_incoming() -> void:
	# Shake Screen effect
	Global.camera.get_node("Node2D").shake(1.0, 1.0)
	Global.screenfx.enable_effect()
	if stun_time.is_stopped():
		stun_time.start()
	pass

func collect(item:InvItem):
	inv.insert(item)
	$weapon.load_weapons()
