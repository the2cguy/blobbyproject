extends Node2D

@export var health:float

func damage(amount:float):
	health -= amount
