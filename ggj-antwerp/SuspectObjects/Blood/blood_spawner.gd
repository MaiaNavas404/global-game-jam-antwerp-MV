extends Node2D

@export var wall_polygons : Array[Polygon2D]
@export var floor_polygons : Array[Polygon2D]

const BLOOD_STAIN = preload("uid://ch4fhu50xyyeq")

func _ready():
	randomize()
	spawn_progression_manager()
	for polygon in wall_polygons:
		polygon.visible = false
	for polygon in floor_polygons:
		polygon.visible = false

func spawn_blood_stain(wall : bool):
	var polygon_to_spawn : Polygon2D
	if wall:
		polygon_to_spawn = wall_polygons.pick_random()
	else:
		polygon_to_spawn = floor_polygons.pick_random()
	var spawn_point := Vector2.ZERO
	spawn_point.x = randf_range(polygon_to_spawn.polygon[0].x, polygon_to_spawn.polygon[1].x) + polygon_to_spawn.position.x
	spawn_point.y = randf_range(polygon_to_spawn.polygon[1].y, polygon_to_spawn.polygon[2].y )+ polygon_to_spawn.position.y
	var spawned_stain = BLOOD_STAIN.instantiate()
	spawned_stain.init_blood(wall)
	spawned_stain.position = spawn_point
	add_child(spawned_stain)

func spawn_progression_manager():
	var number_stains := 2 + ((globals.level - 1) * 3)
	for i in range(number_stains):
		spawn_blood_stain(true)
	for j in range(number_stains):
		spawn_blood_stain(false)
