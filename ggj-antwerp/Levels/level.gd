extends Node2D



func _ready():
	get_viewport().physics_object_picking_first_only = true
	get_viewport().physics_object_picking_sort = true
