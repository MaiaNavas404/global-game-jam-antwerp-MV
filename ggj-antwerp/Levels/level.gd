extends Node2D

@onready var platter := $CanvasLayer/Control/TextureRect
@onready var sponge := $CanvasLayer/Control/TextureRect/Button

func _ready():
	get_viewport().physics_object_picking_first_only = true
	get_viewport().physics_object_picking_sort = true
	platter.visible = false

func _on_texture_button_pressed() -> void:
	platter.visible = true


func _on_button_pressed() -> void:
	$Sponge.disabled = false
