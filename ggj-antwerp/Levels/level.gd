extends Node2D
@onready var sponge: Node2D = $Sponge

func _ready():
	get_viewport().physics_object_picking_first_only = true
	get_viewport().physics_object_picking_sort = true


func _on_sponge_button_pressed() -> void:
	sponge.disabled = false
