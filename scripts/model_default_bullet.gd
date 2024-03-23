extends Area2D

@export var speed:float
@export_range(0.1, 1.0) var knockbackmultiplier:float
# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(get_global_mouse_position())
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta
	


func _on_body_entered(body: Node2D) -> void:
	if body.name != "model_player" and body.has_node("health_component"):
		body.get_node("health_component").damage(1.0)
		if body.has_method("knockbackFunc"): 
			body.knockbackFunc((Vector2.RIGHT * speed * knockbackmultiplier).rotated(rotation))
		queue_free()
		
