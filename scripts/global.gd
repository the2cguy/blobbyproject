extends Node
# Weapons System
var weaponBlueprint:Dictionary = {
	"blitz34":{
		"weaponType":"AUTO",
		"reloadTime": 2.0,
		"rateOfFire": 12,
		"capacity": 30
	},
	"stick":{
		"weaponType":"MELEE",
		"rateOfAttack": 2,
		"damage":0.5,
		"knockback":10
	}
}
var weaponID:int = 0
var weapon
var reload_progress:ProgressBar
var items_ui:HBoxContainer
var itembtn = preload("res://ui/items_btn.tscn")
var health:float = 0
var player:CharacterBody2D

