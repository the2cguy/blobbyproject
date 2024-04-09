extends Node2D
@export var knockback_amount:float
func knockback(knockbackdir):
	print("kvavvennnin")
	get_parent().velocity += knockbackdir * knockback_amount
	print(knockbackdir*knockback_amount)
