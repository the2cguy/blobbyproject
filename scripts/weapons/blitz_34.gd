extends Node2D
@export var bullet:PackedScene

@export var rof:int
@export var reload_time:float
@export var max_capacity:int
var ammo = 16

@onready var reload_bar:Control = Global.UI.get_node("reload_control")

var reload_timer = Timer.new()
var rof_timer = Timer.new() # ROF means Rate Of Fire, how fast the gun is shooting.

func _ready() -> void:
	add_child(reload_timer)
	add_child(rof_timer)
	reload_timer.one_shot = true
	reload_timer.timeout.connect()

func shoot():
	var newbullet = bullet.instantiate()
	newbullet.global_position = $rotate_weapon/Marker2D
	get_tree().root.get_child(0).add_child(newbullet)

func start_reload():
	reload_timer.start(reload_time)
	reload_bar.show()

func reload():
	ammo = max_capacity
	reload_bar.hide()
