extends Node2D
var procedural = FastNoiseLite.new()
var astar:AStarGrid2D = AStarGrid2D.new()
# Background ID: 4
# Dirt ID: 3
# Pine Tree ID: 6
@export var levelArea = [Vector2(-100, -100), Vector2(100, 100)]
@export var seed:int
@export var distribution_frequency = {
	3:0.1146,
	6:0.5
}
@export var layer:Dictionary = {
	"3":0,
	"6":2,
	"4":1
}
@export var atlas_coords = {
	"3":[9, 0],
	"6":[3, 0]
}
@export var tilemap:TileMap
@export var seedidk:int
@onready var navreg:NavigationRegion2D = get_parent().get_node("NavigationRegion2D")
func distribute(seed, atlas_id, frequency, pos1:Vector2i, pos2:Vector2i, isEven:bool, ignoreMap:bool=false):
	if not isEven:
		# set seed
		procedural.seed = seed
		# set noise "scale"/frequency
		procedural.frequency = frequency
		# set noise type, I am using SimplexNoise
		procedural.noise_type = FastNoiseLite.TYPE_SIMPLEX
		# For each tiles in tilemap
		# pos1 and pos2 is range e.g. (0, 0) and (100, 100)
		for x in range(pos1.x, pos2.x):
			for y in range(pos1.y, pos2.y):
				# If tile is blank set cell to desired tile
				if tilemap.get_cell_source_id(5, Vector2i(x, y)) == -1:
					# See documentation for this, for atlas id check the tileset tab below so you know which atlas id. Atlas coords is known by hovering above a tile in tileset tab.
					# "remap" below is used because I want to have a variation of tiles by randomizing the atlas coordinate using noise, see the documentation. (e.g. random trees)
					tilemap.set_cell(layer[str(atlas_id)], Vector2i(x, y), atlas_id, Vector2i(remap(procedural.get_noise_2d(x, y), 0, 1.0, atlas_coords[str(atlas_id)][0], atlas_coords[str(atlas_id)][1]), 0))
				else:
					if ignoreMap:
						tilemap.set_cell(layer[str(atlas_id)], Vector2i(x, y), atlas_id, Vector2i(remap(procedural.get_noise_2d(x, y), 0, 1.0, atlas_coords[str(atlas_id)][0], atlas_coords[str(atlas_id)][1]), 0))
	else:
		for x in range(pos1.x, pos2.x):
			for y in range(pos1.y, pos2.y):
				tilemap.set_cell(layer[str(atlas_id)], Vector2i(x, y), atlas_id, Vector2i(0, 0))

func _ready():
	distribute(seedidk, 3, 0.1146, Vector2i(-100, -100), Vector2i(100, 100), false, true)
	distribute(seedidk, 4, 0, Vector2i(-100, -100), Vector2i(100, 100), true)
	distribute(seedidk, 6, 0.5, Vector2i(-100, -100), Vector2i(100, 100), false)
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("before"):
		seedidk += 1
		distribute(seedidk, 3, 0.1146, Vector2i(-100, -100), Vector2i(100, 100), false, true)
		distribute(seedidk, 4, 0, Vector2i(-100, -100), Vector2i(100, 100), true)
		distribute(seedidk, 6, 0.5, Vector2i(-100, -100), Vector2i(100, 100), false)
#	procedural.seed = seed
#	procedural.noise_type = FastNoiseLite.TYPE_SIMPLEX
#	procedural.frequency = 0.1146
#	for x in range(levelArea[0].x, levelArea[1].x):
#		for y in range(levelArea[0].y, levelArea[1].y):
#			get_parent().get_node("map").set_cell(0, Vector2i(x, y), 3, Vector2i(remap(procedural.get_noise_2d(x, y), 0, 1.0, 9, 0), 0))
#	procedural.seed += 1000
#	procedural.frequency = 0.5
#	for x in range(levelArea[0].x, levelArea[1].x):
#		for y in range(levelArea[0].y, levelArea[1].y):
#			get_parent().get_node("map").set_cell(2, Vector2i(x, y), 6, Vector2i(remap(procedural.get_noise_2d(x, y), 0, 1.0, 3, 0), 0))
#	print(procedural.frequency)

