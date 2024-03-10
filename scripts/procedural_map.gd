extends Node2D
var procedural = FastNoiseLite.new()
# Background ID: 4
# Dirt ID: 3
# Pine Tree ID: 6
var levelArea = [Vector2(-100, -100), Vector2(100, 100)]
func _ready():
	procedural.seed = 7273
	procedural.noise_type = FastNoiseLite.TYPE_SIMPLEX
	procedural.frequency = 0.1146
	for x in range(levelArea[0].x, levelArea[1].x):
		for y in range(levelArea[0].y, levelArea[1].y):
			get_parent().get_node("map").set_cell(1, Vector2i(x, y), 4, Vector2i(0, 0))
			get_parent().get_node("map").set_cell(0, Vector2i(x, y), 3, Vector2i(remap(procedural.get_noise_2d(x, y), 0, 1.0, 9, 0), 0))
	procedural.seed += 1000
	procedural.frequency = 0.5
	for x in range(levelArea[0].x, levelArea[1].x):
		for y in range(levelArea[0].y, levelArea[1].y):
			get_parent().get_node("map").set_cell(2, Vector2i(x, y), 6, Vector2i(remap(procedural.get_noise_2d(x, y), 0, 1.0, 3, 0), 0))
	print(procedural.frequency)

