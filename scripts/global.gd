extends Node
# Weapons System
var guns = []
var current_weapon_id = 0
var weapon:Node2D
var reload_progress:ProgressBar
var items_ui:HBoxContainer
var itembtn = preload("res://ui/items_btn.tscn")
var health:float = 0
