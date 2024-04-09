extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.UI = get_parent()
	Input.set_custom_mouse_cursor(load("res://ui/imgs/cursor_default.png"), Input.CURSOR_ARROW, Vector2(30, 30))



