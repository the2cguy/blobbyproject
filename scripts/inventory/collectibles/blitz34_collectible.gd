extends StaticBody2D

@export var item:InvItem
var player = null
var canCollect:bool = false
@onready var detect:Area2D = $collectible_detect
func hideUI():
	Global.UI.get_node("ui_floating_key").hide()
func showUI():
	Global.UI.get_node("ui_floating_key").show()

func _ready() -> void:
	print("IDK")

func _process(delta: float) -> void:
	if canCollect and Input.is_action_just_pressed("interact"):
		player.collect(item)
		get_tree().create_timer(0.1).timeout.connect(queue_free)
func _on_collectible_detect_body_entered(body: Node2D) -> void:
	if body.name == "model_player":
		player = body
		showUI()
		canCollect = true

func _on_collectible_detect_body_exited(body: Node2D) -> void:
	if body.name == "model_player":
		hideUI()
		canCollect = false
