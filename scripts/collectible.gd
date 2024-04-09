extends Node2D

@export var item:InvItem
@onready var player:CharacterBody2D = Global.player
@onready var sprite:Sprite2D = $Sprite2D
var can_collect:bool = false

func _ready() -> void:
	$Sprite2D.texture = item.texture

func _process(delta: float) -> void:
	if can_collect and Input.is_action_just_pressed("interact"):
		player.collect(item)
		queue_free()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_collect = true
		Global.UI.get_node("ui_floating_key/AnimationPlayer").play("SHOW")
		sprite.material.inspect_native_shader_code()
		$AnimationPlayer.play("shine")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_collect = true
		$AnimationPlayer.play("RESET")
		Global.UI.get_node("ui_floating_key/AnimationPlayer").play("HIDE")
