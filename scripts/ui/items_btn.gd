extends TextureRect
@export var gun_id:int
func change_icon(icon):
	if icon:
		$TextureRect.texture = icon
func _ready() -> void:
	Global.items_ui = get_parent()
