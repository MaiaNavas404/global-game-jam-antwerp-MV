extends Node2D
@onready var sponge: Node2D = $Sponge
@onready var animation_player: AnimationPlayer = $CanvasLayer/Control/AnimationPlayer
@onready var ui: CanvasLayer = $CanvasLayer

func _ready():
	get_viewport().physics_object_picking_first_only = true
	get_viewport().physics_object_picking_sort = true


func _on_sponge_button_pressed() -> void:
	if globals.current_item != globals.Items.SPONGE:
		globals.current_item = globals.Items.SPONGE
	else:
		globals.current_item = globals.Items.NONE
	ui.platter.texture = ui.platter_sprites[globals.current_item]
	animation_player.play("hide_platter")
