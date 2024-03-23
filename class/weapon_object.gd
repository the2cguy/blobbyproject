class_name weaponObject extends Node2D
@export_enum("SEMIAUTO", "AUTO", "MELEE") var weaponType:String = "SEMIAUTO"
@export var weaponUID:String
# Gun Informations
@export_category("Gun")
@export var reloadTime:float
@export var rateOfFire:float
@export var capacity:int
@export var ammo:int
# Melee Informations
@export_category("Melee")
@export var rateOfAttack:float
@export var damage:float
var allowFire = true
var shootDelayTimer:Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shootDelayTimer = Timer.new()
	shootDelayTimer.one_shot = true
	shootDelayTimer.wait_time = 1/rateOfFire
func reduceAmmo(amount:int):
	ammo -= amount
func _fire():
	if ammo > 0 and shootDelayTimer.is_stopped():
		allowFire = true
	reduceAmmo(1)
	allowFire = false
	shootDelayTimer.start()
	return
func _reload():
	ammo = capacity
