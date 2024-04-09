extends Node2D

var shake_amount : float = 0
@onready var camera:Camera2D = get_parent()
@onready var default_offset : Vector2 = get_parent().offset
var pos_x : int
var pos_y : int

@onready var timer : Timer = $Timer
@onready var tween : Tween = get_tree().create_tween()
@onready var rng:RandomNumberGenerator = RandomNumberGenerator.new()
func _ready() -> void:
	set_process(true)
	Global.camera = camera
	randomize()
	timer.one_shot = true
	timer.timeout.connect(stopshake)

func _process(delta: float) -> void:
	camera.offset = Vector2(rng.randf_range(-1, 1)*shake_amount, rng.randf_range(-1, 1)*shake_amount)
	
func shake(time:float, amount:float):
	shake_amount = amount
	set_process(true)
	timer.start(time)
	
func stopshake():
	set_process(false)
	tween.interpolate_value(camera, "offset", 1, 1, tween.TRANS_LINEAR, tween.EASE_IN)
