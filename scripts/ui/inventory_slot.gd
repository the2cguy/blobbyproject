extends Panel

@onready var item_texture: Sprite2D = $CenterContainer/Panel/item_texture
@onready var select_texture = preload("res://ui/imgs/ui_inventory_slot_selected.png")
@onready var default_texture = preload("res://ui/imgs/ui_inventory_slot.png")
var is_hover:bool = false

func update(slot:InvSlot):
	if !slot.item:
		item_texture.visible = false
	else:
		item_texture.visible = true
		item_texture.texture = slot.item.texture
	
func select():
	$CenterContainer/Panel/TextureRect.texture = select_texture
	$AnimationPlayer.play("hover")
func unselect():
	$CenterContainer/Panel/TextureRect.texture = default_texture
	$AnimationPlayer.play("back")

func _on_mouse_entered() -> void:
	is_hover = true
	select()


func _on_mouse_exited() -> void:
	is_hover = false
	unselect()
