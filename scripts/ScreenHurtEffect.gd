extends CanvasModulate

func enable_effect():
	$AnimationPlayer.play("hurt")

func _ready() -> void:
	Global.screenfx = self
