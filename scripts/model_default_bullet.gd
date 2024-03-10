extends Area2D

@export var speed:float
# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(get_global_mouse_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta
