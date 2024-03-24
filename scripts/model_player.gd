extends CharacterBody2D

@export var speed = 400.0
@export var sprint_speed:float
@onready var noise = FastNoiseLite.new()
@onready var navreg:NavigationRegion2D = get_parent().get_node("NavigationRegion2D")
var isShake = false
var noise_y = 0.0
var amount:int
func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	Global.player = self
func _process(delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_pressed("sprint"):
		velocity = lerp(velocity, dir * sprint_speed, 0.02)
	else:
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
	Global.health = $health_component.health
	if isShake:
		$Camera2D.offset = Vector2(noise.get_noise_2d(noise.seed, noise_y) * amount * 2, noise.get_noise_2d(noise.seed, noise_y) * amount)
		noise_y += 1
		amount -= 1 * delta
	if Input.is_action_just_pressed("next"):
		navreg.bake_navigation_polygon(true)
func _on_health_component_damage_incoming() -> void:
	pass
	#amount = 100
	#isShake = true

