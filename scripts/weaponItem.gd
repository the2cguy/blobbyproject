extends Resource
class_name weaponItem

@export var name:String
@export var capacity:int
@export var reload_time:float
@export var ammo:int
@export var ROF:int
@export_enum("SEMIAUTO","AUTO","MELEE") var weapon_type:String
@export var knockback:float
@export var damage:float
