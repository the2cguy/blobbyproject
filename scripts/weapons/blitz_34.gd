extends Node2D
@export var bullet:PackedScene
enum weapon_types {AUTO, SEMIAUTO, MELEE, SPECIAL}
@export var rof:int
@export var reload_time:float
@export var max_capacity:int
var current_weapon:bool = false
var ammo = max_capacity
@export var weapon_type = "AUTO"
@onready var reload_bar:Control = Global.UI.get_node("reload_control")

var reload_timer = Timer.new()
var rof_timer = Timer.new() # ROF means Rate Of Fire, how fast the gun is shooting.

func _ready() -> void:
	add_child(reload_timer)
	add_child(rof_timer)
	reload_timer.one_shot = true
	reload_timer.timeout.connect(reload)
	rof_timer.one_shot = true
func shoot():
	if rof_timer.is_stopped() and ammo > 0 and reload_timer.is_stopped():
		$rotate_weapon/AnimatedSprite2D.play("shooting")
		var newbullet = bullet.instantiate()
		newbullet.global_position = $rotate_weapon/Marker2D.global_position
		get_tree().root.get_child(0).add_child(newbullet)
		rof_timer.start(1/float(rof))
		ammo -= 1
		Global.UI.get_node("AmmoBar").max_ammo = max_capacity
		Global.UI.get_node("AmmoBar").update_ammo(ammo)

func _process(delta: float) -> void:
	if current_weapon:
		$rotate_weapon.look_at(get_global_mouse_position())
		if Vector2.RIGHT.rotated($rotate_weapon.rotation).x < 0:
			$rotate_weapon/AnimatedSprite2D.flip_v = true
		else:
			$rotate_weapon/AnimatedSprite2D.flip_v = false
		reload_bar.get_node("reload_progress").value = reload_timer.time_left
		Glob
		
	
func start_reload():
	if reload_timer.is_stopped():
		reload_timer.start(reload_time)
		reload_bar.show()
		reload_bar.get_node("reload_progress").max_value = reload_time

func reload():
	ammo = max_capacity
	reload_bar.hide()
